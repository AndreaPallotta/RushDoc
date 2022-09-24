//
//  DoctorsListRegistrationView.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/9/21.
//

import SwiftUI

struct DoctorsListRegistrationView: View {
    
    @State private var showGoBackAlert: Bool = false
    @State private var goBackToHomepage: Bool = false
    @State private var searchText: String = ""
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    private var title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        VStack {
            Text("\(self.title)")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.backgroundBlue)
                .padding(.top, 30)
            
            SearchBar(text: $searchText)
                .padding([.top, .bottom])
            
            ScrollView {
                VStack {
                    DoctorCard(doctor: DoctorModel(image: Image("doctor"), name: "Dr. Mariah Hairam", job: "Orthopedic Physician", lat: 43.106430, long: -77.749970, yearsOfExperience: 10, rating: 2.7, destination: SelectTimeDateView(doctor: DoctorModel(image: Image("doctor"), name: "Dr. Mariah Hairam", job: "Orthopedic Physician", lat: 43.106430, long: -77.749970, yearsOfExperience: 10, rating: 2.7)).toAnyView()))
                        .padding(.bottom, 10)
                    
                    DoctorCard(doctor: DoctorModel(image: Image("doctor"), name: "Dr. John Nhoj", job: "Orthopedic Surgeons", lat: 43.004260, long: -76.170610, yearsOfExperience: 12, rating: 4.5, destination: SelectTimeDateView(doctor: DoctorModel(image: Image("doctor"), name: "Dr. John Nhoj", job: "Orthopedic Surgeons", lat: 43.004260, long: -76.170610, yearsOfExperience: 12, rating: 4.5)).toAnyView()))
                }
            }
            
            Spacer()
            BottomArrows(visitedNextPage: .constant(false), nextView: EmptyView().toAnyView(), pageNo: 2)
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
                                    RegistrationStep(true)
                                    RegistrationStep(false)
                                    RegistrationStep(false)
                                }
                                .padding(.trailing, 30)
        )
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

