//
//  ProfileView.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 4/22/21.
//

import SwiftUI
import CoreGraphics

struct ProfileView: View {
    
    @State private var users: [DBUserModel] = []
    @State private var userModel: DBUserModel? = nil
    @State private var text: String = ""
    @State private var openManageAccount: Bool = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    private var address: String
    
    init() {
        self.address = UserDefaults.standard.string(forKey: "user_address") ?? "Address not found"
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                ZStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.mode.wrappedValue.dismiss()
                        }, label: {
                            Text("Log out")
                                .foregroundColor(.white)
                        })
                        .padding(.trailing, 25)
                        .padding(.top, 10)
                    }
                }
                .frame(width: UIScreen.screenWidth, height: nil)
                .background(
                    CurvedSideRectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.gradientLightBlue, Color.backgroundBlue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(height: 350)
                        .shadow(radius: 10, y: 5))
                
                VStack {
                    Text("Your profile")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom)
                    
                    ProfileHeaderCard(name: "\(userModel?.firstName ?? "") \(userModel?.lastName ?? "")", address: "\(address.noPunc)", action: {self.openManageAccount.toggle()})
                    .padding(.bottom, 10)
                        .sheet(isPresented: $openManageAccount, content: {
                            ManageAccountView(userModel: $userModel)
                        })
                    
                    ProfileContentCard(title: "Personal Information", titleIcon: Image(systemName: "info.circle"), fields: [
                        ProfileFieldModel(name: "Manage my Account", image: Image(systemName: "person.crop.circle")),
                        ProfileFieldModel(name: "Privacy and Safety", image: Image(systemName: "lock.shield")),
                        ProfileFieldModel(name: "Favorite Doctors", image: Image(systemName: "star.circle")),
                    ])
                    .padding(.bottom, 10)
                    
                    ProfileContentCard(title: "Medical Information", titleIcon: Image(systemName: "heart.circle"), fields: [
                        ProfileFieldModel(name: "Health Profile", image: Image(systemName: "person.crop.circle")),
                        ProfileFieldModel(name: "Medical ID", image: Image(systemName: "viewfinder.circle"))
                    ])
                    .padding(.bottom, 10)
                }
                Spacer()
            }
            .hiddenNavigationBarStyle()
            .onAppear(perform: {
                self.userModel = DBManager().getUserByEmail(emailValue: UserDefaults.standard.string(forKey: "user_email") ?? "")
            })
        }
        .hiddenNavigationBarStyle()

    }
}


/// https://www.youtube.com/watch?v=7_vScyZP6EM
struct CurvedSideRectangle: Shape {
    var topOffset: CGFloat = 0
    var bottomOffset: CGFloat = 50
    
    var animatableData: CGFloat {
        get { return bottomOffset }
        set { bottomOffset = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + topOffset))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + topOffset),
                          control: CGPoint(x: rect.midX, y: rect.minY - topOffset))
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomOffset))
        
        path.addQuadCurve(to: CGPoint(x: 0, y: rect.maxY - bottomOffset),
                          control: CGPoint(x: rect.midX, y: rect.maxY + bottomOffset))
        
        path.closeSubpath()
        
        return path
    }
}

