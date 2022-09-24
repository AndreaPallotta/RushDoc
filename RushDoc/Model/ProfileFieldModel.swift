//
//  ProfileFieldModel.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/8/21.
//

import Foundation
import SwiftUI

class ProfileFieldModel: Identifiable {
    var image: Image
    var name: String
    var destination: AnyView?
    
    init (name: String, destination: AnyView?, image: Image) {
        self.name = name
        self.destination = destination
        self.image = image
    }
    
    init (name: String, image: Image) {
        self.name = name
        self.image = image
    }
}
