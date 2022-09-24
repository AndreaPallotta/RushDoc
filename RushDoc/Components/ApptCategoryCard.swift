//
//  ApptCategoryCard.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/9/21.
//

import SwiftUI

struct ApptCategoryCard: View {
    
    private var card: ApptCategoryCardModel
    @State private var isActive: Bool = false
    
    init (card: ApptCategoryCardModel) {
        self.card = card
    }
     
    var body: some View {
        NavigationLink(
            destination: self.card.destination,
            isActive: $isActive,
            label: {
                Button(action: {
                    UserDefaults.standard.set(self.card.title, forKey: "appt_category")
                    self.isActive.toggle()
                }, label: {
                    VStack {
                        Image(self.card.image)
                            .resAndFit
                        Text(self.card.title)
                            .foregroundColor(.backgroundBlue)
                            .bold()
                            .font(.title2)
                    }
                })
                .frame(width: 150, height: 120)
                .padding(10)
                .overlay (
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.lightGray, lineWidth: 3.0)
                )
                .background(Color.white)
                .modifier(CardModifier(cornerRadius: 20))
            })
            .disabled(self.card.destination == nil)
        
            
    }
}
