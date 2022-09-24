//
//  AccountManageCard.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/8/21.
//

import SwiftUI
import iPhoneNumberField

struct AccountManageCard: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var phone_number: String
    @Binding var isEdit: Bool
    
    init(email: Binding<String>, password: Binding<String>, phone_number: Binding<String>, isEdit: Binding<Bool>) {
        self._email = email
        self._password = password
        self._phone_number = phone_number
        self._isEdit = isEdit
    }
    
    var body: some View {
        VStack {
            EditableAccountManageRow(label: "Email", text: $email, isEdit: $isEdit, placeholder: email)
            EditableAccountManageRow(label: "Password", text: $password, isEdit: $isEdit, placeholder: password)
            EditableAccountManageRow(label: "Phone Number", text: $phone_number, isEdit: $isEdit, placeholder: phone_number, isPhoneNumber: true)
            
        }
        .padding([.top, .bottom], 30)
        .frame(maxWidth: UIScreen.screenWidth - 30)
        .overlay (
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.lightGray, lineWidth: 3.0)
                .frame(height: 200)
        )
        .background(Color.white)
        .modifier(CardModifier(cornerRadius: 15))
    }
}

struct EditableAccountManageRow: View {
    
    private var label: String
    private var isPhoneNumber: Bool = false
    private var placeholder: String
    @Binding var text: String
    @Binding var isEdit: Bool
    
    init(label: String, text: Binding<String>, isEdit: Binding<Bool>, placeholder: String) {
        self._text = text
        self._isEdit = isEdit
        self.label = label
        self.placeholder = placeholder
    }
    
    init(label: String, text: Binding<String>, isEdit: Binding<Bool>, placeholder: String, isPhoneNumber: Bool) {
        self._text = text
        self._isEdit = isEdit
        self.label = label
        self.placeholder = placeholder
        self.isPhoneNumber = isPhoneNumber
    }
    
    
    var body: some View {
        HStack {
            
            Text(self.label)
                .font(.title2)
                .bold()
                .foregroundColor(.backgroundBlue)
                .fitInLine(lines: 1)
            
            Spacer()
            
            if isPhoneNumber {
                iPhoneNumberField(text: $text)
                    .formatted(true)
                    .flagHidden(false)
                    .flagSelectable(true)
                    .maximumDigits(10)
                    .prefixHidden(true)
                    .placeholderColor(Color.backgroundBlue)
                    .foregroundColor(Color.backgroundBlue)
                    .padding(5)
                    .border(self.isEdit ? Color.backgroundBlue.opacity(0.7) : Color.white, width: 1)
                    .cornerRadius(10)
                    .disabled(!isEdit)
                    .fixedSize(horizontal: true, vertical: true)
                    .padding(.trailing)
            } else {
                CustomTextField(text: $text, placeholder: Text("\(self.placeholder)"), isSecure: false)
                    .padding(5)
                    .border(self.isEdit ? Color.backgroundBlue.opacity(0.7) : Color.white, width: 1)
                    .cornerRadius(10)
                    .foregroundColor(.backgroundBlue)
                    .disabled(!isEdit)
                    .fixedSize(horizontal: true, vertical: true)
                    .padding(.trailing)
            }
        }
        .padding(.leading)
        .padding(.top, 10)
    }
}
