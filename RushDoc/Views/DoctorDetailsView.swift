//
//  DoctorDetailsView.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/10/21.
//

import SwiftUI

struct DoctorDetailsView: View {
    
    @State private var isFavorite: Bool = false
    private var doctor: DoctorModel
    
    init(doctor: DoctorModel) {
        self.doctor = doctor
    }
    
    var body: some View {
        VStack {
            ZStack {
                
            }
            .frame(width: UIScreen.screenWidth, height: nil)
            .background(
                CurvedSideRectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.gradientLightBlue, Color.backgroundBlue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 350)
                    .shadow(radius: 10, y: 5))
            
            Text("Doctor Details")
                .font(.title)
                .bold()
                .foregroundColor(.white)
                .padding([.top, .bottom])
            
            DoctorHeaderCard(doctor: self.doctor, isFavorite: $isFavorite)
            
            MapWithRouteView(doctor: self.doctor)
                
            
            Spacer()
        }
        .onAppear {
            let favs = UserDefaults.standard.stringArray(forKey: "favorite_doctors") ?? []
            self.isFavorite = favs.contains(self.doctor.name)
        }
    }
}

