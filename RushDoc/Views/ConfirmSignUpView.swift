//
//  ConfirmSignUpView.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 2/11/21.
//

import SwiftUI
import UIKit
import UIColor_Hex_Swift
import ToastUI

struct ConfirmSignUpView: View {
    
    @State private var numberOfCells: Int = 5
    @State private var currentlySelectedCell = 0
    @State private var showErrorToast: Bool = false
    @State private var goToHomepage: Bool = false
    @State private var addUserToDBResult: Bool = false
    @Binding var isActive: Bool
    
    @EnvironmentObject var present: presentFromLanding
    @ObservedObject private var userModel: UserModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    init(isActive: Binding<Bool>, userModel: UserModel) {
        self._isActive = isActive
        self.userModel = userModel
    }
    
    var body: some View {
        VStack {
            Text("Confirm Sign Up")
            Text("A message containing your confirmation code has been sent to your phone number")
            
            HStack {
                ForEach(0 ..< self.numberOfCells) { index in
                    CharacterInputCell(currentlySelectedCell: self.$currentlySelectedCell, index: index)
                        .padding(10)
                }
            }
            .padding(40)
            
            NavigationLink(
                destination: NavBarView(),
                isActive: $present.goToHomepage,
                label: {
                    LargeButtonBackground(text: "Confirm", action: {
                        self.addUserToDBResult = DBManager().addUser(firstNameValue: userModel.firstName.trimWS, lastNameValue: userModel.lastName.trimWS, emailValue: userModel.email.lowercased().trimWS, phoneNumberValue: userModel.phoneNumber, passwordValue: userModel.password.trimWS)

                        if self.addUserToDBResult == true {
                            self.present.goToHomepage = true
                            self.present.presentSignUp = false
                        } else {
                            self.showErrorToast = true
                        }
                    })
                    .toast(isPresented: $showErrorToast) {
                        ToastView {
                            VStack {
                                Text("Error inserting user")
                                    .bold()
                                    .font(.title)
                                    .padding(.bottom, 5)
                                
                                Text("Email or Phone Number already taken.")
                                    .padding(.bottom)
                                    .font(.title3)
                                
                                Button(action: {
                                    self.showErrorToast = false
                                    self.mode.wrappedValue.dismiss()
                                }, label: {
                                    Text("Go back to sign up")
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                        .padding(.vertical, 12.0)
                                        .background(Color.accentColor)
                                        .cornerRadius(8.0)
                                })
                                
                            }
                        }
                    }
                    
                })
            
            LargeButtonClear(text: "Back to Landing", action: {self.present.presentSignUp = false})
        }
        
        .hiddenNavigationBarStyle()
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
    }
}

struct CharacterInputCell: View {
    @State private var textValue: String = ""
    @Binding var currentlySelectedCell: Int
    
    var index: Int
    
    var responder: Bool {
        return index == currentlySelectedCell
    }
    
    var body: some View {
        OneFieldTextField(text: $textValue, currentlySelectedCell: $currentlySelectedCell, isFirstResponder: responder)
            .frame(height: 20)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding([.trailing, .leading], 10)
            .padding([.vertical], 10)
            .foregroundColor(.backgroundBlue)
            .cornerRadius(10)
            .lineLimit(1)
            .multilineTextAlignment(.center)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.backgroundBlue.opacity(0.8), lineWidth: 1)
                    .shadow(color: Color.black.opacity(0.25), radius: 4, x: 2, y: 2)
            )
        
    }
}

struct OneFieldTextField: UIViewRepresentable {
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        @Binding var currentlySelectedCell: Int
        
        var didBecomeFirstResponder = false
        
        init(text: Binding<String>, currentlySelectedCell: Binding<Int>) {
            _text = text
            _currentlySelectedCell = currentlySelectedCell
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.text = textField.text ?? ""
            }
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""
            
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.count <= 1 {
                self.currentlySelectedCell += 1
            }
            
            return updatedText.count <= 1
        }
    }
    
    @Binding var text: String
    @Binding var currentlySelectedCell: Int
    var isFirstResponder: Bool = false
    
    func makeUIView(context: UIViewRepresentableContext<OneFieldTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.textColor = UIColor(Constants.UIKitBackgroundBlue)
        textField.textContentType = .oneTimeCode
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        
        return textField
    }
    
    func makeCoordinator() -> OneFieldTextField.Coordinator {
        return Coordinator(text: $text, currentlySelectedCell: $currentlySelectedCell)
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<OneFieldTextField>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}
