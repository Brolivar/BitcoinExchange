//
//  AppURL.swift
//  BitcoinExchange
//
//  Created by Jose Bolivar on 19/12/24.
//

import Foundation

enum Currency: String {
    case usd = "USD"
    case eur = "EUR"
    case gbp = "GBP"
}


class AppURL {

    private static let baseURL = "https://api.coindesk.com/v1/bpi/historical/close.json"

    static func bitcoinPriceURL(for currency: Currency) -> URL? {
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -14, to: endDate)!

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let startString = dateFormatter.string(from: startDate)
        let endString = dateFormatter.string(from: endDate)

        let urlString = "\(baseURL)?start=\(startString)&end=\(endString)&currency=\(currency.rawValue)"

        return URL(string: urlString)
    }
}
