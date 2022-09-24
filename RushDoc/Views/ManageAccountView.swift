//
//  ManageAccountView.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/8/21.
//

import SwiftUI
import ToastUI
import Regex

struct ManageAccountView: View {
    
    @SceneStorage("ManageAccountView.savedEmail") private var savedEmail: String?
    @SceneStorage("ManageAccountView.savedPassword") private var savedPassword: String?
    @SceneStorage("ManageAccountView.savedPhoneNumber") private var savedPhoneNumber: String?
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var phone_number: String = ""
    @State private var isEdit: Bool = false
    @State private var showErrorToast: Bool = false
    @Binding var userModel: DBUserModel?
    private var address: String
    private let regexEmail: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    init(userModel: Binding<DBUserModel?>) {
        self._userModel = userModel
        address = UserDefaults.standard.string(forKey: "user_address") ?? "Address not found"
    }
    
    func validateEmailRegex(_ input: String) -> Bool {
        return input.trimmingCharacters(in: .whitespacesAndNewlines) =~ self.regexEmail.r
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                ZStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            if self.isEdit {
                                if email.isEmpty || !validateEmailRegex(email) || password.isEmpty || phone_number.isEmpty {
                                    self.showErrorToast.toggle()
                                    self.email = savedEmail!
                                    self.password = savedPassword!
                                    self.phone_number = savedPhoneNumber!
                                } else {
                                    
                                    if (DBManager().updateUser(uIdValue: Int64(UserDefaults.standard.integer(forKey: "user_id")), emailValue: self.email, passwordValue: self.password, phoneNumberValue: self.phone_number)) {
                                        self.savedEmail = self.email
                                        self.savedPassword = self.password
                                        self.savedPhoneNumber = self.phone_number
                                    } else {
                                        self.showErrorToast.toggle()
                                        self.email = savedEmail!
                                        self.password = savedPassword!
                                        self.phone_number = savedPhoneNumber!
                                    }
                                }
                            }
                            withAnimation(.easeIn) {
                                self.isEdit.toggle()
                            }
                        }, label: {
                            Text("\(!self.isEdit ? "Edit" : "Done")")
                                .foregroundColor(.white)
                        })
                        .padding(.trailing, 25)
                        .padding(.top, 10)
                        .toast(isPresented: $showErrorToast, dismissAfter: 1.0) {
                        } content: {
                            ToastView("Error saving new values.\nOne or more form fields are wrong")
                                .toastViewStyle(ErrorToastViewStyle())
                        }
                    }
                }
                
                .frame(width: UIScreen.screenWidth, height: nil)
                .background(
                    CurvedSideRectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.gradientLightBlue, Color.backgroundBlue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(height: 350)
                        .shadow(radius: 10, y: 5))
                
                VStack {
                    Text("Manage Your Account")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding([.top, .bottom])
                    
                    AccountManageCard(email: $email, password: $password, phone_number: $phone_number, isEdit: $isEdit)
                        .padding(.bottom, 10)
                }
                
                Spacer()
            }
            .onAppear(perform: {
                self.email = self.savedEmail ?? userModel?.email ?? ""
                self.password = self.savedPassword ?? userModel?.password ?? ""
                self.phone_number = self.savedPhoneNumber ?? userModel?.phoneNumber ?? ""
                
                if self.savedEmail == nil || self.savedPassword == nil || self.savedPhoneNumber == nil {
                    self.savedEmail = self.email
                    self.savedPassword = self.password
                    self.savedPhoneNumber = self.phone_number
                }
            })
            .hiddenNavigationBarStyle()
        }
        .hiddenNavigationBarStyle()
    }
}
