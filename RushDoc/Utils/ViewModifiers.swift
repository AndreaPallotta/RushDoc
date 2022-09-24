//
//  ViewModifiers.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 4/22/21.
//

import Foundation
import SwiftUI

struct CardModifier: ViewModifier {
    let cornerRadius: CGFloat
    func body(content: Content) -> some View {
        content
            .cornerRadius(cornerRadius)
            .shadow(color: Color.black.opacity(0.115), radius: 10, x: 0, y: 14)
    }
}

struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}
