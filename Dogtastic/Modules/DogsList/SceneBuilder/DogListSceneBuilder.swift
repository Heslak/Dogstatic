//
//  DogListSceneBuilder.swift
//  Dogtastic
//
//  Created by Sergio Acosta on 23/11/23.
//

import Foundation

class DogListSceneBuilder {
    
    func build() -> DogListViewController {
        let repository = DogListRepository()
        let useCase = DogListUseCase(repository: repository)
        let viewModel = DogListViewModel(useCase: useCase)
        let controller = DogListViewController(viewModel: viewModel)
        return controller
    }
}
