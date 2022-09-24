//
//  ValidationModel.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 4/22/21.
//

import Foundation

enum Validation {
    case success
    case failure(message: String)
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
}
