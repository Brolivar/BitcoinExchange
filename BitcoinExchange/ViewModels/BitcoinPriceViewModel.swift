//
//  BitcoinPriceViewModel.swift
//  BitcoinExchange
//
//  Created by Jose Bolivar on 19/12/24.
//
import Foundation

// This would normally be abstracted into a protocol
class BitcoinPriceViewModel {

    // MARK: - Properties

    // NetworkManager should be inyected from (future) Coordinator
    private let networkManager = NetworkManager()

    // Datasource to handle each bitcoin price (we use date to identify it)
    var bitcoinPrices: [BitcoinPrice] = []
    var currentPrice: BitcoinPrice? {
        didSet {
            self.onCurrentPriceUpdate?()
        }
    }
    // Update the current price periodically
    private var timer: Timer?
    private let updateFrequency: TimeInterval = 60

    // Data Bindings
    var onPricesUpdated: (() -> Void)?
    var onCurrentPriceUpdate: (() -> Void)?
    var onError: ((String) -> Void)?

    func fetchPrices() {
        let currencies: [Currency] = [.usd, .eur, .gbp]

        // Concurrent requests through DispatchGroup
        let group = DispatchGroup()

        // Store the different currencies for later combination.
        var usdPrices: [BitcoinPrice] = []
        var eurPrices: [BitcoinPrice] = []
        var gbpPrices: [BitcoinPrice] = []

        // Make a request for each currency - API does not support several currencies in same request
        for currency in currencies {
            group.enter()
            guard let url = AppURL.bitcoinPriceURL(for: currency) else {
                group.leave()
                return
            }

            self.networkManager.fetchBitcoinPrices(from: url) { [weak self] result in
                switch result {
                case .success(let responseModel):
                    let prices = responseModel.bpi.map { (date, price) -> BitcoinPrice in
                        BitcoinPrice(date: date, usdPrice: currency == .usd ? price : 0, eurPrice: currency == .eur ? price : 0, gbpPrice: currency == .gbp ? price : 0)
                    }

                    switch currency {
                    case .usd:
                        usdPrices = prices
                    case .eur:
                        eurPrices = prices
                    case .gbp:
                        gbpPrices = prices
                    }
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
                group.leave()
            }
        }

        // After all the requests are done, combine all the currencies into the same date object.
        group.notify(queue: .main) {
            for index in 0..<usdPrices.count {
                let usd = usdPrices[index]
                let eur = eurPrices.first { $0.date == usd.date }
                let gbp = gbpPrices.first { $0.date == usd.date }

                let combinedPrice = BitcoinPrice(
                    date: usd.date,
                    usdPrice: usd.usdPrice,
                    eurPrice: eur?.eurPrice ?? 0,
                    gbpPrice: gbp?.gbpPrice ?? 0
                )

                self.bitcoinPrices.append(combinedPrice)
            }

            // Sort by date (newest to oldest)
            self.bitcoinPrices.sort { $0.date > $1.date }

            self.onPricesUpdated?()
        }
    }

    // Fetch the current price of bitcoin
    func fetchCurrentPrice() {
        guard let url = AppURL.currentBitcoinPriceURL() else {
            return
        }

        self.networkManager.fetchCurrentBitcoinPrices(from: url) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let usdPrice = responseModel.bpi[Currency.usd.rawValue]?.rate_float ?? 0
                let eurPrice = responseModel.bpi[Currency.eur.rawValue]?.rate_float ?? 0
                let gbpPrice = responseModel.bpi[Currency.gbp.rawValue]?.rate_float ?? 0

                self?.currentPrice = BitcoinPrice(
                    date: responseModel.time.updated,
                    usdPrice: usdPrice,
                    eurPrice: eurPrice,
                    gbpPrice: gbpPrice
                )
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }

    // Start the timer to fetch the current price every 30 seconds
    func startPriceUpdateTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: self.updateFrequency, repeats: true) { [weak self] _ in
            self?.fetchCurrentPrice()
        }
    }

    // Stop the timer when no longer needed
    func stopPriceUpdateTimer() {
        timer?.invalidate()
        timer = nil
    }
}
