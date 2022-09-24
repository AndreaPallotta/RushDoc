//
//  LargeButtonBackground.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 2/10/21.
//

import SwiftUI

struct LargeButtonBackground: View {
    private var text: String
    private var action: () -> Void
    @Binding private var isValid: Bool
    
    init(text: String, action: @escaping () -> Void, isValid: Binding<Bool>) {
        self.text = text
        self.action = action
        self._isValid = isValid
    }
    
    init(text: String, action: @escaping () -> Void) {
        self._isValid = .constant(true)
        self.text = text
        self.action = action
    }
    
    
    var body: some View {
        Button(action: self.action, label: {
            Text(self.text)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .font(.system(size: 22))
                .frame(minWidth: 190, minHeight: 38)
        })
        .padding()
        .background(isValid ? Color.backgroundBlue : Color.gray)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
        
        
    }
}

struct LargeTextBackground: View {
    private var text: String
    private var action: () -> Void
    
    init(text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    
    init(text: String) {
        self.text = text
        self.action = {}
    }
    
    var body: some View {
        VStack {
            Text(self.text)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .font(.system(size: 22))
                .frame(minWidth: 190, minHeight: 38)
        }
        .onTapGesture {
            self.action()
        }
        .padding()
        .background(Color.backgroundBlue)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
        
        
    }
}
