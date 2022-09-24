//
//  RatingStars.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/10/21.
//

import SwiftUI

/// https://stackoverflow.com/questions/64379079/how-to-present-accurate-star-rating-using-swiftui/64389917
struct RatingStars: View {
    private var rating: CGFloat
    
    init(rating: CGFloat) {
        self.rating = rating
    }
    
    var body: some View {
        let stars = HStack(spacing: 0) {
            ForEach(0..<5) { _ in
                Image(systemName: "star.fill")
                    .resizable()
                    .square(30)
                    .style(.bold)
                    .padding(.leading, 5)
                    .shadow(radius: 1, x: 0, y: 3)
            }
        }
        
        stars.overlay(
            GeometryReader { g in
                let width = rating / CGFloat(5) * g.size.width
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .foregroundColor(.starYellow)
                    
                }
                
            }
            
            .mask(stars)
            
        )
        .foregroundColor(.gray)
        
    }
}

struct RatingStars_Previews: PreviewProvider {
    static var previews: some View {
        RatingStars(rating: 3.5)
    }
}
