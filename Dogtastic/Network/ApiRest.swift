//
//  ApiRest.swift
//  Dogtastic
//
//  Created by Sergio Acosta on 23/11/23.
//

import Foundation
import Combine

class ApiRest {
    
    static let shared = ApiRest()
    private var urlSession = URLSession(configuration: .default)
    
    private init() { }
    
    func get<T: Decodable>(component: String) -> AnyPublisher<T, Error>? {
        guard let url = Dogstatic.fullUrl?.appending(component: component) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return urlSession.dataTaskPublisher(for: request).tryMap() {
            guard $0.data.count > 0 else { throw URLError(.zeroByteResource) }
            return $0.data
        }.decode(type: T.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func get(from url: String) -> AnyPublisher<Data, Error>? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return urlSession.dataTaskPublisher(for: request).tryMap() {
            guard $0.data.count > 0 else { throw URLError(.zeroByteResource) }
            return $0.data
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
