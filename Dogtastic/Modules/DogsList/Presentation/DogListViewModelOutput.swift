//
//  DogListViewModelOutput.swift
//  Dogtastic
//
//  Created by Sergio Acosta on 23/11/23.
//

import Foundation
import Combine

struct DogListViewModelOutput {
    let fillWithDataPublisher = PassthroughSubject<Void, Error>()
    let showErrorAlertPublisher = PassthroughSubject<Void, Never>()
}
