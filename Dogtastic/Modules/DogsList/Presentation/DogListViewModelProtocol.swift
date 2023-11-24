//
//  DogListViewModelProtocol.swift
//  Dogtastic
//
//  Created by Sergio Acosta on 23/11/23.
//

import Foundation

protocol DogListViewModelProtocol {
    var dogs: [Dog] { get set }
    
    func bind(input: DogListViewModelInput) -> DogListViewModelOutput
}
