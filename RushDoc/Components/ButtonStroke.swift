//
//  ButtonStroke.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/9/21.
//

import SwiftUI

struct ClearButtonStroke: View {
    private var text: String
    private var action: () -> Void
    
    init(text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button(action: self.action, label: {
            Text(self.text)
                .foregroundColor(.backgroundBlue)
                .multilineTextAlignment(.center)
                .font(.system(size: 15))
                .padding([.top, .bottom], 10)
                .padding([.leading, .trailing])
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gradientLightBlue, lineWidth: 3)
                )
        })
        
        
    }
}

struct BackgroundButtonStroke: View {
    private var text: String
    private var action: () -> Void
    
    init(text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button(action: self.action, label: {
            Text(self.text)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .font(.system(size: 15))
                .padding([.top, .bottom], 10)
                .padding([.leading, .trailing])
                
        })
        .background(Color.backgroundBlue)
        .cornerRadius(10)
    }
}
