//
//  NetworkingManager.swift
//  Crypto
//
//  Created by PC on 27/09/22.
//

import Foundation
import Combine

class NetworkingManager{

    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unKnown

        var errorDescription: String?{
            switch self {
            case .badURLResponse(url: let url): return "[🔥] Bad response from URL"
            case .unKnown: return "[⚠️] Unknown error occured"
            }
        }
    }

    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handelURLResponse(Output: $0, url: url)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    static func handelURLResponse(Output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = Output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
                  throw NetworkingError.badURLResponse(url: url)
              }
        return Output.data
    }

    static func handleCompletion(completion: Subscribers.Completion<Error>){
        switch completion {
        case .finished:
            break

        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
