//
//  BitcoinResponse.swift
//  BitcoinExchange
//
//  Created by Jose Bolivar on 19/12/24.
//
import Foundation

// Model containing the API response
struct BitcoinPriceResponseModel: Decodable {
    let bpi: [String: Double]   // Currency code as key, price as value
}
