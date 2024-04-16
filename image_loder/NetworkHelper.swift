//
//  NetworkHelper.swift
//  image_loder
//
//  Created by Mahipal on 16/04/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case decodingError
}

class NetworkHelper {
    static func fetchData<T: Decodable>(from url: URL, responseModel: T.Type) async -> Result<T, NetworkError> {
        
        do {
            
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                return .failure(.invalidResponse)
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return .success(decodedData)
            } catch {
                return .failure(.decodingError)
            }
            
        } catch {
             return .failure(.requestFailed)
        }
            
    }
}
