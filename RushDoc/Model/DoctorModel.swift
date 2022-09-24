//
//  DoctorModel.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/9/21.
//

import Foundation
import CoreLocation
import SwiftUI

class DoctorModel: Identifiable {
    var image: Image
    var name: String
    var job: String
    var lat: Double = 0
    var long: Double = 0
    var yearsOfExperience: Int
    var rating: Double
    var destination: AnyView?
    
    init(image: Image, name: String, job: String, lat: Double, long: Double, yearsOfExperience: Int, rating: Double, destination: AnyView?) {
        self.image = image
        self.name = name
        self.job = job
        self.lat = lat
        self.long = long
        self.yearsOfExperience = yearsOfExperience
        self.rating = rating
        self.destination = destination
    }
    
    init(image: Image, name: String, job: String, lat: Double, long: Double, yearsOfExperience: Int, rating: Double) {
        self.image = image
        self.name = name
        self.job = job
        self.lat = lat
        self.long = long
        self.yearsOfExperience = yearsOfExperience
        self.rating = rating
    }
    
}
