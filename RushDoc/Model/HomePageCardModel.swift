//
//  HomePageCardModel.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 4/22/21.
//

import Foundation
import SwiftUI

class Card: Identifiable {
    var image: String
    var title: String
    var subtitle: String
    var destination: AnyView?
    
    init (image: String, title: String, subtitle: String, destination: AnyView?) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.destination = destination
    }
    
    init (image: String, title: String, subtitle: String) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
    }

}

class ApptCategoryCardModel: Identifiable {
    var image: String
    var title: String
    var destination: AnyView?
    
    init (image: String, title: String, destination: AnyView?) {
        self.image = image
        self.title = title
        self.destination = destination
    }
    
    init (image: String, title: String) {
        self.image = image
        self.title = title
    }
}
