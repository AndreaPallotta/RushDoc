//
//  LoginView.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 2/11/21.
//

import SwiftUI
import LocalAuthentication
import ToastUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSecured: Bool = true
    @State private var rememberCredentials: Bool = false
    @State private var user: DBUserModel? = nil
    @State private var isActive: Bool = false
    @State private var showFormErrorToast: Bool = false
    @State private var formErrorToastText: String = ""
    
    @EnvironmentObject var present: presentFromLanding
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject private var userModel = UserModel()
    
    var body: some View {
        VStack {
            Image("logo")
            
            Divider()
            
            LoginFields(email: $email, text: $password, isSecured: $isSecured)
            .padding(.top, 80)
            
            HStack(alignment: .center) {
                HStack {
                    Button(action: {self.rememberCredentials.toggle()}, label: {
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(self.rememberCredentials ? Color.textGreen : Color.backgroundBlue)
                            .frame(width: 20, height: 20)
                        
                        Text("Remember Credentials")
                            .font(.system(size: 15))
                            .fontWeight(.regular)
                            .foregroundColor(self.rememberCredentials ? Color.textGreen : Color.backgroundBlue)
                        
                            
                    })
                    .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 2)
                }
                .padding(.leading, 40)
                
                Spacer()
            }
            .frame(width: UIScreen.screenWidth)
            .padding(.top, 30)
            
            VStack {
                Button(action: {}, label: {
                    Text("Forgot Password")
                        .font(.system(size: 18))
                        .fontWeight(.regular)
                        .foregroundColor(.backgroundBlue)
                })

            }
            .frame(width: UIScreen.screenWidth, alignment: .center)
            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 2)
            .padding(.top, 25)
            
            NavigationLink(
                destination: NavBarView(),
                isActive: $isActive,
                label: {
                    LargeButtonBackground(text: "Sign In", action: {
                        if (self.email != "" && self.password != "") {
                            
                            self.user = DBManager().getUserByEmail(emailValue: self.email.lowercased().trimWS)
                            if (self.user?.password == self.password.trimWS) {
                                if (self.rememberCredentials) {
                                    UserDefaults.standard.set(true, forKey: "remember_credentials")
                                    UserDefaults.standard.set(user?.email, forKey: "user_email")
                                    UserDefaults.standard.set(user?.password, forKey: "user_password")
                                }  else {
                                    UserDefaults.standard.set(false, forKey: "remember_credentials")
                                    UserDefaults.standard.removeObject(forKey: "user_email")
                                    UserDefaults.standard.removeObject(forKey: "user_password")
                                }
                                UserDefaults.standard.set(user?.uId, forKey: "user_id")
                                self.present.presentLogin = false
                                self.present.goToHomepage = true
                                self.isActive = true

                            } else {
                                self.showFormErrorToast = true
                                self.formErrorToastText = "Email or Password are wrong"
                            }
                            
                        } else {
                            self.showFormErrorToast = true
                            self.formErrorToastText = "Login Form contains errors"
                        }
                    })
                    .padding(.top, 5)
                })
                .toast(isPresented: $showFormErrorToast, dismissAfter: 1.0) {
                } content: {
                    ToastView("\(self.formErrorToastText)")
                        .toastViewStyle(ErrorToastViewStyle())
                }
            
            Text("Or sign in with")
                .foregroundColor(.backgroundBlue)
                .multilineTextAlignment(.center)
                .font(.system(size: 20))
                .frame(minWidth: 190, minHeight: 38)
            
            LoginBottomIcons(isActive: $isActive).environmentObject(self.present)
        }
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        .onAppear(perform: {
            if (UserDefaults.standard.bool(forKey: "remember_credentials")) {
                self.rememberCredentials = true
                self.email = UserDefaults.standard.string(forKey: "user_email") ?? ""
                self.password = UserDefaults.standard.string(forKey: "user_password") ?? ""
            }
            
        })
        
        
    }
}

enum BiometricType {
    case touch
    case face
    case none
}

func getBiometricType() -> BiometricType {
    
    let authenticationContext = LAContext()
    _ = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    switch (authenticationContext.biometryType){
    case .faceID:
        return .face
    case .touchID:
        return .touch
    default:
        return .none
    }
}

struct LoginBottomIcons: View {
    
    @EnvironmentObject var present: presentFromLanding
    @Binding var isActive: Bool 
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        UserDefaults.standard.set(true, forKey: "remember_credentials")
                        UserDefaults.standard.set("ap4534@rit.edu", forKey: "user_email")
                        UserDefaults.standard.set("password", forKey: "user_password")
                        
                        self.present.presentLogin = false
                        self.present.goToHomepage = true
                        self.isActive = true
                    }
                }
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 60) {
            Button(action: {}, label: {
                Image("Facebook")
                    .resAndFill
                    .square(60)
            })
            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 2)
            
            Button(action: {}, label: {
                Image("Google")
                    .resizable()
                    .scaledToFill()
                    .square(60)
                    
            })
            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 2)
            
            Button(action: {
                authenticate()
            }, label: {
                if getBiometricType() == .face {
                    Image(systemName: "faceid")
                        .resizable()
                        .scaledToFill()
                        .square(45)
                }  else if getBiometricType() == .touch {
                    Image(systemName: "touchid")
                        .resizable()
                        .scaledToFill()
                        .square(45)
                } else {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFill()
                        .square(45)
                }
                
                    
            })
            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 2)
        }
        .padding(.top, 25)
    }
}

struct LoginFields: View {
    
    @Binding var email: String
    @Binding var text: String
    @Binding var isSecured: Bool
    
    init(email: Binding<String>, text: Binding<String>, isSecured: Binding<Bool>) {
        self._email = email
        self._text = text
        self._isSecured = isSecured
    }
    var body: some View {
        VStack {
            CustomTextField(text: $email, placeholder: Text("Email"), isSecure: false)
                .padding(20)
                .border(Color.backgroundBlue.opacity(0.7), width: 1)
                .cornerRadius(10)
                .foregroundColor(.backgroundBlue)
                .frame(width: 325, height: 50, alignment: .leading)
           
            HStack() {
                CustomTextField(text: $text, placeholder: Text("Password"), isSecure: isSecured)
                    .padding()
                    .foregroundColor(.backgroundBlue)
                    
                
                Button(action: {self.isSecured.toggle()}, label: {
                    Image(systemName: isSecured ? "eye.slash" : "eye")
                        .resAndFill
                        .foregroundColor(Color.backgroundBlue.opacity(0.7))
                        .square(20)
                        .padding(.trailing, 15)
                    
                        
                })
                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 2)
            }
            .border(Color.backgroundBlue.opacity(0.6), width: 1)
            .cornerRadius(10)
            .padding(.top, 25)
            .frame(width: 325, height: 50, alignment: .leading)
            
            
        }
    }
}

