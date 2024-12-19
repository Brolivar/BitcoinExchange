//
//  BitcoinPrice.swift
//  BitcoinExchange
//
//  Created by Jose Bolivar on 19/12/24.
//

import Foundation

// App model containing the Bitcoin price and the different prices. We can use the date as id.
struct BitcoinPrice {
    let date: String
    let usdPrice: Double
    let eurPrice: Double
    let gbpPrice: Double
}
