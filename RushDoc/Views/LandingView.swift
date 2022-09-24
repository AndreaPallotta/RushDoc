//
//  LandingView.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 2/10/21.
//

import SwiftUI

struct LandingView: View {
    
    @State var presentLogin: Bool = false
    @State var presentSignUp: Bool = false
    private var db: DBManager
    
    @ObservedObject var present = presentFromLanding()
    
    init() {
        self.db = DBManager()
    }
    
    var body: some View {
        VStack {
            Image("logo")
                .padding(.bottom, 200)

            VStack {
                LargeButtonBackground(text: "Sign In", action: {self.present.presentLogin = true})
                    .sheet(isPresented: self.$present.presentLogin, content: {
                        LoginView()
                            .environmentObject(self.present)
                    })
                
                LargeButtonClear(text: "Sign Up", action: {self.present.presentSignUp = true})
                    .sheet(isPresented: self.$present.presentSignUp, content: {
                        SignUpView()
                            .environmentObject(self.present)
                    })
            }
            
            NavigationLink(destination: NavBarView(),
                           isActive: $present.goToHomepage) {
                                EmptyView()
                            }
        }
        .hiddenNavigationBarStyle()
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        .toNavView()
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
