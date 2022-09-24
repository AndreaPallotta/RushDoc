//
//  DoctorApptRegistrationView.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/9/21.
//

import SwiftUI
import UIKit
import iPhoneNumberField

struct DoctorApptRegistrationView: View {
    @State private var showGoBackAlert = false
    @State private var visitedSecondPage: Bool = false
    @State private var userModel: DBUserModel? = nil
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    private var pageNo: Int = 0
    
    var body: some View {
        VStack {
            
            Text("Appointment for:")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.backgroundBlue)
                .padding(.top, 30)
            
            UserCard(name: "\(userModel?.firstName ?? "") \(userModel?.lastName ?? "")", image: Image("placeholder_user"), destination: SelectCategoryApptRegistrationView(visitedSecondPage: $visitedSecondPage).toAnyView())
                .padding([.leading, .trailing], 10)
                .padding(.top, 50)
            
            Spacer()
            
            LargeButtonBackground(text: "Add Family Member", action: {})
            BottomArrows(visitedNextPage: $visitedSecondPage, nextView: SelectCategoryApptRegistrationView(visitedSecondPage: $visitedSecondPage).toAnyView(), pageNo: 0)
                .padding([.top, .bottom])
            
        }
        .navigationBarItems(leading:
                                Button(action: {
                                    self.showGoBackAlert.toggle()
                                }) {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.backgroundBlue)
                                },
                            trailing:
                                HStack {
                                    RegistrationStep(true)
                                    RegistrationStep(false)
                                    RegistrationStep(false)
                                    RegistrationStep(false)
                                    RegistrationStep(false)
                                }
                                .padding(.trailing, 30)
        )
        .frame(width: UIScreen.screenWidth)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("")
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $showGoBackAlert, content: {
            Alert(
                title: Text("Are you sure you want to go back to the main menu?"),
                message: Text("Your appointment draft will be deleted permanently."),
                primaryButton: .destructive(Text("Go to Homepage")) {
                    self.mode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel())
        })
        .onAppear(perform: {
            if self.userModel == nil {
                self.userModel = DBManager().getUserByEmail(emailValue: UserDefaults.standard.string(forKey: "user_email") ?? "")
            }
        })
    }
}

struct DoctorApptRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorApptRegistrationView()
    }
}
