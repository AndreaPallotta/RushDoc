//
//  SignUpView.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 2/11/21.
//

import SwiftUI
import iPhoneNumberField
import ToastUI

struct SignUpView: View {
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    @State private var isSecured: Bool = true
    @State private var goToConfirmSignUp: Bool = false
    @State private var isActive: Bool = false
    @State private var showFormErrorToast: Bool = false
    
    @EnvironmentObject var present: presentFromLanding
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject private var userModel = UserModel()
    
    var body: some View {
        VStack {
            Image("logo")
            
            Divider()
            
            SignUpForm(firstName: $userModel.firstName, lastName: $userModel.lastName, email: $userModel.email, phoneNumber: $userModel.phoneNumber, password: $userModel.password, repeatPassword: $repeatPassword, isSecured: $isSecured, userModel: userModel)
                .padding(.top,30)
            
            NavigationLink(
                destination: ConfirmSignUpView(isActive: $isActive, userModel: userModel).environmentObject(self.present),
                isActive: $isActive,
                label: {
                    LargeButtonBackground(text: "Sign Up", action: {
                        self.isActive = self.userModel.isSignUpValid
                        self.showFormErrorToast = !self.userModel.isSignUpValid
                    })
                    .padding(.top, 30)
                })
                .toast(isPresented: $showFormErrorToast, dismissAfter: 2.0) {
                } content: {
                    ToastView("Error in sign up form")
                        .toastViewStyle(ErrorToastViewStyle())
                }
            
        }
        .hiddenNavigationBarStyle()
        .background(Color.clear)
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        .toNavView()
        
    }
}

struct SignUpForm: View {
    
    @Binding private var firstName: String
    @Binding private var lastName: String
    @Binding private var email: String
    @Binding private var phoneNumber: String
    @Binding private var password: String
    @Binding private var repeatPassword: String
    @Binding private var isSecured: Bool
    @State private var isEditing: Bool = false
    private var userModel: UserModel
    
    init(firstName: Binding<String>, lastName: Binding<String>, email: Binding<String>, phoneNumber: Binding<String>, password: Binding<String>, repeatPassword: Binding<String>, isSecured: Binding<Bool>, userModel: UserModel) {
        self._firstName = firstName
        self._lastName = lastName
        self._email = email
        self._phoneNumber = phoneNumber
        self._password = password
        self._repeatPassword = repeatPassword
        self._isSecured = isSecured
        self.userModel = userModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            CustomTextField(text: $firstName, placeholder: Text("First Name"), isSecure: false)
                .padding(20)
                .border(Color.backgroundBlue.opacity(0.7), width: 1)
                .cornerRadius(10)
                .foregroundColor(.backgroundBlue)
                .frame(width: 325, height: 50, alignment: .leading)
            
            CustomTextField(text: $lastName, placeholder: Text("Last Name"), isSecure: false)
                .padding(20)
                .border(Color.backgroundBlue.opacity(0.7), width: 1)
                .cornerRadius(10)
                .foregroundColor(.backgroundBlue)
                .frame(width: 325, height: 50, alignment: .leading)
            
            CustomTextField(text: $email, placeholder: Text("Email"), isSecure: false)
                .padding(20)
                .border(Color.backgroundBlue.opacity(0.7), width: 1)
                .cornerRadius(10)
                .foregroundColor(.backgroundBlue)
                .frame(width: 325, height: 50, alignment: .leading)
                .keyboardType(.emailAddress)
            
            iPhoneNumberField(text: $phoneNumber)
                .formatted(true)
                .flagHidden(false)
                .flagSelectable(true)
                .maximumDigits(10)
                .prefixHidden(true)
                .placeholderColor(Color.backgroundBlue)
                .foregroundColor(Color.backgroundBlue)
                .padding(20)
                .border(Color.backgroundBlue.opacity(0.7), width: 1)
                .cornerRadius(10)
                .frame(width: 325, height: 50, alignment: .leading)
            
            HStack() {
                CustomTextField(text: $password, placeholder: Text("Password"), isSecure: isSecured)
                    .padding(20)
                    .foregroundColor(.backgroundBlue)
                
                Button(action: {self.isSecured.toggle()}, label: {
                    Image(systemName: isSecured ? "eye.slash" : "eye")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(Color.backgroundBlue.opacity(0.7))
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 15)
                    
                    
                })
                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 2)
            }
            .border(Color.backgroundBlue.opacity(0.6), width: 1)
            .cornerRadius(10)
            .padding(.top, 25)
            .padding(.bottom, 25)
            .frame(width: 325, height: 50, alignment: .leading)
            
            CustomTextField(text: $repeatPassword, placeholder: Text("Repeat Password"), isSecure: isSecured)
                .padding(20)
                .border(Color.backgroundBlue.opacity(0.7), width: 1)
                .cornerRadius(10)
                .foregroundColor(.backgroundBlue)
                .frame(width: 325, height: 50, alignment: .leading)
            
            
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
