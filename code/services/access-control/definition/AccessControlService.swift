//
//  File.swift
//  
//
//  Created by Ross Butler on 22/07/2020.
//

import Foundation

protocol AccessControlService {
    func isUnlocked(_ identifier: UUID, completion: @escaping (Bool) -> Void)
}
