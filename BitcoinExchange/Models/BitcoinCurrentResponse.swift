//
//  BitcoinCurrentResponse.swift
//  BitcoinExchange
//
//  Created by Jose Bolivar on 20/12/24.
//

import Foundation

struct BitcoinCurrentPriceResponse: Decodable {
    let time: Time
    let disclaimer: String
    let chartName: String
    let bpi: [String: BitcoinPriceDetail]

    struct Time: Decodable {
        let updated: String
        let updatedISO: String
        let updateduk: String
    }

    struct BitcoinPriceDetail: Decodable {
        let code: String
        let symbol: String
        let rate: String
        let description: String
        let rate_float: Double
    }
}
