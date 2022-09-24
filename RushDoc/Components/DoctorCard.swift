//
//  DoctorCard.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/9/21.
//

import SwiftUI
import CoreLocation
import MapKit
import UIKit

struct DoctorCard: View {
    
    private var doctor: DoctorModel
    private var buttonsHide: Bool
    @State private var placemark: CLPlacemark?
    @State private var showDoctorDetails: Bool = false
    @State private var goToNext: Bool = false
    @ObservedObject var locationManager = LocationManager()
    
    init(doctor: DoctorModel) {
        self.doctor = doctor
        self.buttonsHide = false
    }
    
    init(doctor: DoctorModel, buttonsHide: Bool) {
        self.doctor = doctor
        self.buttonsHide = buttonsHide
    }
    
    var body: some View {
        NavigationLink(
            destination: self.doctor.destination,
            isActive: $goToNext,
            label: {
                VStack {
                    HStack {
                        Image("doctor")
                            .resAndFit
                            .square(100)
                        
                        VStack(alignment: .leading) {
                            Text(doctor.name)
                                .font(.title)
                                .bold()
                                .fitInLine(lines: 1)
                                .foregroundColor(.backgroundBlue)
                            Text(doctor.job)
                                .font(.title2)
                                .fitInLine(lines: 1)
                                .foregroundColor(.backgroundBlue)
                            
                            Text(UserDefaults.standard.string(forKey: "\(doctor.name)_address") ?? "No Address")
                                .font(.subheadline)
                                .fitInLine(lines: 1)
                                .style(.thin)
                                .foregroundColor(.backgroundBlue)
                                .padding(.top, 5)
                        }
                    }
                    .padding(.bottom)
                    
                    if !buttonsHide {
                        HStack(alignment: .center, spacing: 30.0) {
                            ClearButtonStroke(text: "View Profile", action: {self.showDoctorDetails.toggle()})
                            NavigationLink(destination: self.doctor.destination) {
                                BackgroundButtonStroke(text: "Book Appointment", action: {self.goToNext.toggle()})
                            }
                        }
                    }
                    
                }.padding([.top, .bottom], 30)
                .frame(maxWidth: UIScreen.screenWidth - 30)
                .overlay (
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.lightGray, lineWidth: 3.0)
                )
                .onTapGesture {
                    self.goToNext.toggle()
                }
                .sheet(isPresented: $showDoctorDetails) {
                    DoctorDetailsView(doctor: self.doctor)
                }
                .onAppear(perform: {
                    let location = CLLocation(latitude: doctor.lat, longitude: doctor.long)
                    location.placemark { placemark, error in
                        guard let placemark = placemark else {
                            print("Error: ", error ?? "nil")
                            return
                        }
                        self.placemark = placemark
                        if self.placemark != nil {
                            UserDefaults.standard.setValue(self.placemark?.mailingAddress?.newLines.joined(separator: ", "), forKey: "\(doctor.name)_address")
                        }
                    }
                })
                .background(Color.white)
                .modifier(CardModifier(cornerRadius: 15))
            })
    }
}
