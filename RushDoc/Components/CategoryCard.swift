//
//  CategoryCard.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 4/22/21.
//

import SwiftUI

struct CategoryCard: View {
    
    private var card: Card
    
    init (card: Card) {
        self.card = card
    }
     
    var body: some View {
        NavigationLink(
            destination: self.card.destination,
            label: {
                VStack {
                    Image(self.card.image)
                        .resAndFit
                    Text(self.card.title)
                        .foregroundColor(.backgroundBlue)
                        .bold()
                        .font(.title)
                        
                    Text(self.card.subtitle)
                        .foregroundColor(.backgroundBlue)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                }
                .square(150)
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


