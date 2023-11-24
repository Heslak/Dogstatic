//
//  Dogstatic.swift
//  Dogtastic
//
//  Created by Sergio Acosta on 23/11/23.
//

import Foundation

enum Dogstatic {
    static var baseUrl: String = "https://jsonblob.com/"
    static var apiVersion: String = "api"
    static var fullUrl: URL? {
        get {
            return URL(string: Dogstatic.baseUrl+Dogstatic.apiVersion)
        }
    }
}
