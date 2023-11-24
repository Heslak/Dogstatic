//
//  DogListViewModel.swift
//  Dogtastic
//
//  Created by Sergio Acosta on 23/11/23.
//

import Foundation
import Combine

class DogListViewModel: DogListViewModelProtocol {
    
    private let useCase: DogListUseCaseProtocol
    private var subscribers = Set<AnyCancellable>()
    private var outputViewModel = DogListViewModelOutput()
    var dogs: [Dog] = [Dog]()
    var fromLocal: Bool = false
    
    init(useCase: DogListUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func bind(input: DogListViewModelInput) -> DogListViewModelOutput {

        input.viewDidLoadPublisher.sink{ [weak self] in
            self?.fetchData()
        }.store(in: &subscribers)

        input.loadDataPublisher.sink{ [weak self] in
            self?.fetchData()
        }.store(in: &subscribers)
        
        return outputViewModel
    }
    
    private func fetchData() {
        if fromLocal {
            getLocalDogs()
        } else {
            getDogs()
        }
    }
    
    private func getDogs() {
        useCase.getDogs()?.sink { [weak self] error in
            switch error {
            case .finished:
                break
            case .failure(_):
                self?.outputViewModel.showErrorAlertPublisher.send()
            }
        } receiveValue: { [weak self] dogs in
            self?.dogs = dogs.sorted { $0.age < $1.age }
            self?.outputViewModel.fillWithDataPublisher.send()
            self?.fromLocal = self?.useCase.setLocalDogs(dogs: dogs) ?? false
        }.store(in: &subscribers)
    }
    
    private func getLocalDogs() {
        useCase.getLocalDogs()?.sink { [weak self] error in
            switch error {
            case .finished:
                break
            case .failure(_):
                self?.outputViewModel.showErrorAlertPublisher.send()
            }
        } receiveValue: { [weak self] dogs in
            self?.dogs = dogs
            self?.outputViewModel.fillWithDataPublisher.send()
        }.store(in: &subscribers)
    }
}
