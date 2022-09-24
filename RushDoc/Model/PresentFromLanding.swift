//
//  PresentFromLanding.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 4/22/21.
//

import Foundation

class presentFromLanding: ObservableObject {
    @Published var presentLogin: Bool = false
    @Published var presentSignUp: Bool = false
    @Published var goToHomepage: Bool = false
}
