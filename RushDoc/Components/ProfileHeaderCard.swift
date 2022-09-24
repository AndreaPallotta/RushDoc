//
//  ProfileHeaderCard.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/8/21.
//

import SwiftUI

struct ProfileHeaderCard: View {
    
    private var name: String
    private var address: String
    private var action: () -> Void = {}
    private var cornerRadius: CGFloat
    private var hideGear: Bool = false
    @State private var profilePic: Image? = Image("placeholder_user")
    
    init (name: String, address: String, action: @escaping () -> Void) {
        self.name = name
        self.address = address
        self.action = action
        self.cornerRadius  = 15.0
    }
    
    init (name: String, address: String, hideGear: Bool) {
        self.name = name
        self.address = address
        self.cornerRadius  = 15.0
        self.hideGear = hideGear
    }
     
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                ProfilePicture(profilePic: $profilePic)
                
                Button(action: self.action, label: {
                    Image(systemName: "gearshape")
                        .resizable()
                        .square(25)
                        .foregroundColor(.backgroundBlue)
                })
                .padding(.leading, 280)
                .padding(.bottom, 30)
                .hide(hideGear)
                
            }
            .frame(width: UIScreen.screenWidth)
            .padding(.top, 10)
            
            Text(self.name)
                .foregroundColor(.backgroundBlue)
                .bold()
                .font(.title)
            
            Divider()
                .padding([.leading, .trailing], 50)
                
            Text(self.address)
                .foregroundColor(.backgroundBlue)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.bottom)
                .padding([.leading, .trailing], 10)
            Spacer()
            
        }
        .frame(maxWidth: UIScreen.screenWidth - 30, maxHeight: 200)
        .overlay (
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.lightGray, lineWidth: 3.0)
                .frame(height: 200)
                
                
        )
        .background(Color.white)
        .modifier(CardModifier(cornerRadius: 15))
            
    }
}
