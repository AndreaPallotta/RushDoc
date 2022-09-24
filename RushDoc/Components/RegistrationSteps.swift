//
//  RegistrationSteps.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/9/21.
//

import SwiftUI

struct RegistrationStep: View {
    
    private var isActive: Bool
    
    init(_ isActive: Bool) {
        self.isActive = isActive
    }
    
    var body: some View {
        if isActive {
            
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black.opacity(0.7), lineWidth: 3)
                .background(Color.backgroundBlue)
                .shadow(color: Color.black.opacity(0.115), radius: 4, x: 0, y: 4)
                .frame(width: 50)
            
        } else {
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.backgroundBlue.opacity(0.7), lineWidth: 3)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.115), radius: 4, x: 0, y: 4)
                .frame(width: 50)
            
        }
    }
}
