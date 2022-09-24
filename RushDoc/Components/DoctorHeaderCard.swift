//
//  DoctorHeaderCard.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/10/21.
//

import SwiftUI

struct DoctorHeaderCard: View {
    
    @Binding var isFavorite: Bool
    private var doctor: DoctorModel
    
    init(doctor: DoctorModel, isFavorite: Binding<Bool>) {
        self._isFavorite = isFavorite
        self.doctor = doctor
    }
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                self.doctor.image
                    .resAndFit
                    .square(100)
                    .clipShape(Circle())
                    .shadow(radius: 10)
        
                Button(action: {
                    var favs = UserDefaults.standard.stringArray(forKey: "favorite_doctors") ?? []
                    if !favs.contains(self.doctor.name) {
                        favs.append(self.doctor.name)
                        self.isFavorite = true
                    } else {
                        favs = favs.filter {$0 != self.doctor.name}
                        self.isFavorite = false
                    }
                    UserDefaults.standard.set(favs, forKey: "favorite_doctors")
                }, label: {
                    Image(systemName: self.isFavorite ? "star.fill" : "star")
                        .resizable()
                        .square(30)
                        .style(.bold)
                        .foregroundGradient(colors: [Color.starYellow, Color.lightGray])
                })
                .padding(.leading, 280)
                .padding(.bottom, 50)
                
            }
            .padding(.top, 10)
            
            Text(self.doctor.name)
                .foregroundColor(.backgroundBlue)
                .bold()
                .font(.title)
            
            Text(self.doctor.job)
                .foregroundColor(.backgroundBlue)
                .font(.title2)
            
            Divider()
                .padding(5)
            
            Text(UserDefaults.standard.string(forKey: "\(self.doctor.name)_address") ?? "No Address")
                
                .foregroundColor(.backgroundBlue)
                .font(.subheadline)
                .fitInLine(lines: 1)
                .padding([.leading, .trailing], 10)
                .padding(.top, 5)
            
            Text("\(self.doctor.yearsOfExperience) years of experience")
                .foregroundColor(.backgroundBlue)
                .font(.caption)
                .padding(.top, 5)
            
            HStack {
                RatingStars(rating: CGFloat(self.doctor.rating))
            }
            .padding(.bottom)
            
        }
        .frame(maxWidth: UIScreen.screenWidth - 30)
        .overlay (
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.lightGray, lineWidth: 3.0)
        )
        .background(Color.white)
        .modifier(CardModifier(cornerRadius: 15))
    }
}


