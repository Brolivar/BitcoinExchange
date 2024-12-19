//
//  NetworkManager.swift
//  BitcoinExchange
//
//  Created by Jose Bolivar on 19/12/24.
//

// EXAMPLE RESPONSES:
// https://api.coindesk.com/v1/bpi/currentprice/BTC.json
// https://api.coindesk.com/v1/bpi/historical/close.json?start=2024-12-18&end:2024-12-18&currency=EUR

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}

class NetworkManager {

    // Note: I have seen unexpected behavior on the API. In rare cases for the same request, it would return way more dates than intended.
    // This might have something to do with the removal of the official CoinDesk documentation.
    func fetchBitcoinPrices(from url: URL, completion: @escaping (Result<BitcoinPriceResponseModel, NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.requestFailed))
                return
            }
            do {
                let decoder = JSONDecoder()
                let responseModel = try decoder.decode(BitcoinPriceResponseModel.self, from: data)
                completion(.success(responseModel))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }
        task.resume()
    }
}
