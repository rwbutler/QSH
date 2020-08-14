//
//  URLAdditions.swift
//  
//
//  Created by Ross Butler on 14/08/2020.
//

import Foundation
import ArgumentParser

extension URL: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(string: argument)
    }
}
