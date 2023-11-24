//
//  DogListUseCaseProtocol.swift
//  Dogtastic
//
//  Created by Sergio Acosta on 23/11/23.
//

import Foundation
import Combine

protocol DogListUseCaseProtocol {
    func getDogs() -> AnyPublisher<[Dog], Error>?
    
    func setLocalDogs(dogs: [Dog]) -> Bool
    func getLocalDogs() -> AnyPublisher<[Dog], Error>?
}
