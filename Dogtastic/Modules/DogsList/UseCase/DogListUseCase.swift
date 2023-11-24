//
//  DogListUseCase.swift
//  Dogtastic
//
//  Created by Sergio Acosta on 23/11/23.
//

import Foundation
import Combine

class DogListUseCase: DogListUseCaseProtocol {
    
    private let repository: DogListRepositoryProtocol
    
    init(repository: DogListRepositoryProtocol) {
        self.repository = repository
    }
    
    func getDogs() -> AnyPublisher<[Dog], Error>? {
        return repository.getDogs()
    }
    
    func setLocalDogs(dogs: [Dog]) -> Bool {
        return repository.setLocalDogs(dogs: dogs)
    }
    
    func getLocalDogs() -> AnyPublisher<[Dog], Error>? {
        return repository.getLocalDogs()
    }
}
