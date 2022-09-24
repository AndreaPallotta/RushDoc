//
//  UserCard.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/9/21.
//

import SwiftUI

struct UserCard: View {
    
    private var name: String
    private var image: Image
    private var destination: AnyView?
    @State private var isActive: Bool = false
    
    init(name: String, image: Image, destination: AnyView?) {
        self.name = name
        self.image = image
        self.destination = destination
    }
    
    var body: some View {
        NavigationLink(
            destination: self.destination,
            isActive: $isActive,
            label: {
                Button(action: {
                    UserDefaults.standard.set(self.name, forKey: "appt_user_name")
                    self.isActive.toggle()
                }, label: {
                    HStack {
                        self.image
                            .resAndFit
                            .padding([.top, .bottom, .trailing])
                        Text(self.name)
                            .foregroundColor(.backgroundBlue)
                            .bold()
                            .font(.title)
                    }
                })
                .frame(maxWidth: UIScreen.screenWidth - 70, maxHeight: 100)
                .overlay (
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.lightGray, lineWidth: 3.0)
                )
                .background(Color.white)
                .modifier(CardModifier(cornerRadius: 20))
            })
            .disabled(self.destination == nil)
    }
}
