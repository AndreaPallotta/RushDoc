//
//  LargeButtonClear.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 2/10/21.
//

import SwiftUI

struct LargeButtonClear: View {
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
                .font(.system(size: 22))
                .frame(minWidth: 190, minHeight: 38)
        })
        .padding()
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 2)
        
        
    }
}

struct LargeTextClear: View {
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
                .foregroundColor(.backgroundBlue)
                .multilineTextAlignment(.center)
                .font(.system(size: 22))
                .frame(minWidth: 190, minHeight: 38)
        }
        .onTapGesture {
            self.action()
        }
        .padding()
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 2)
        
        
    }
}


