//
//  CustomTextField.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 2/11/21.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var text: String
    var placeholder: Text
    var isSecure: Bool
    var editingChanged: (Bool) -> () = { _ in }
    var commit:  () -> () = { }
    
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .font(.system(size: 15))
                    .fontWeight(.light)
                
            }
            if isSecure {
                SecureField("", text: $text, onCommit: commit)
            } else {
                TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
            }
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(text: Binding.constant(""), placeholder: Text("placeholder"), isSecure: false)
    }
}
