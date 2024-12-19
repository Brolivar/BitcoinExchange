//
//  BitcoinPriceViewModel.swift
//  BitcoinExchange
//
//  Created by Jose Bolivar on 19/12/24.
//
import Foundation

class BitcoinPriceViewModel {

    // TODO: - NetworkManager should be inyected from (future) Coordinator
    private let networkManager = NetworkManager()

    // Datasource to handle each bitcoin price (we use date to identify it)
    var bitcoinPrices: [BitcoinPrice] = []
    var onPricesUpdated: (() -> Void)?
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
}
