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

// NOTE: An alternative, more optimal approach would be to make a single request and handle the conversion between currencies on the client side.
// However, for the purposes of this project, I chose to focus on demonstrating networking and handling multiple API requests.
class NetworkManager {

    // MARK: IMPORTANT NOTE - I've observed occasional unexpected behavior with the API.
    // In some cases, a single request returns more dates than expected.
    // This could be related to the removal of the official CoinDesk documentation, potentially indicating discontinued official support.
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

    func fetchCurrentBitcoinPrices(from url: URL, completion: @escaping (Result<BitcoinCurrentPriceResponse, NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.requestFailed))
                return
            }
            do {
                let decoder = JSONDecoder()
                let responseModel = try decoder.decode(BitcoinCurrentPriceResponse.self, from: data)
                completion(.success(responseModel))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }
        task.resume()
    }
}
