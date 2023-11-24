//
//  DogListViewModelInput.swift
//  Dogtastic
//
//  Created by Sergio Acosta on 23/11/23.
//

import Foundation
import Combine

struct DogListViewModelInput {
    let viewDidLoadPublisher = PassthroughSubject<Void, Never>()
    let loadDataPublisher = PassthroughSubject<Void, Never>()
}
