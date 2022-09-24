//
//  SelectCategoryApptRegistrationView.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/9/21.
//

import SwiftUI
import QGrid

struct SelectCategoryApptRegistrationView: View {
    
    @State private var showGoBackAlert: Bool = false
    @State private var goBackToHomepage: Bool = false
    @State private var activeCategoryTitle: String = ""
    @Binding var visitedSecondPage: Bool
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    private var cards: [ApptCategoryCardModel]?
    
    init(visitedSecondPage: Binding<Bool>) {
        self._visitedSecondPage = visitedSecondPage
        self.cards = [
            ApptCategoryCardModel(image: "general_medicine", title: "General Medicine"),
            ApptCategoryCardModel(image: "cardiology", title: "Cardiology"),
            ApptCategoryCardModel(image: "orthopedics", title: "Orthopedics", destination: DoctorsListRegistrationView(title: "Orthopedics").toAnyView()),
            ApptCategoryCardModel(image: "neurology", title: "Neurology"),
            ApptCategoryCardModel(image: "sports_medine", title: "Sports Medicine"),
            ApptCategoryCardModel(image: "general_surgery", title: "General Surgery")
        ]
    }
    
    var body: some View {
        VStack {
            Text("Select Category")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.backgroundBlue)
                .padding(.top, 30)
            
            QGrid(cards!,
                  columns: 2,
                  vSpacing: 20,
                  hSpacing: 10) {
                ApptCategoryCard(card: $0)
            }
            
            Spacer()
            
            
            BottomArrows(visitedNextPage: .constant(false), nextView: DoctorsListRegistrationView(title: activeCategoryTitle).toAnyView(), pageNo: 1)
                .padding(.bottom)
        }
        .navigationBarItems(leading:
                                NavigationLink(
                                    destination: HomepageView().toAnyView(),
                                    isActive: $goBackToHomepage,
                                    label: {
                                        Button(action: {
                                            self.showGoBackAlert.toggle()
                                        }) {
                                            Image(systemName: "chevron.left")
                                                .foregroundColor(.backgroundBlue)
                                        }
                                    }),
                            trailing:
                                HStack {
                                    RegistrationStep(true)
                                    RegistrationStep(true)
                                    RegistrationStep(false)
                                    RegistrationStep(false)
                                    RegistrationStep(false)
                                }
                                .padding(.trailing, 30)
        )
        .onAppear(perform: {
            visitedSecondPage = true
        })
        .alert(isPresented: $showGoBackAlert, content: {
            Alert(
                title: Text("Are you sure you want to go back to the main menu?"),
                message: Text("Your appointment draft will be deleted permanently."),
                primaryButton: .destructive(Text("Go to Homepage")) {
                    self.goBackToHomepage = true
                },
                secondaryButton: .cancel())
        })
        .frame(width: UIScreen.screenWidth)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("")
        
    }
}

