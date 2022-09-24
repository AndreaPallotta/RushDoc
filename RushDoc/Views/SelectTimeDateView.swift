//
//  SelectTimeDateView.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/10/21.
//

import SwiftUI

struct SelectTimeDateView: View {
    
    private var doctor: DoctorModel

    @State private var pickedDate = Date.tomorrow
    @State private var showGoBackAlert: Bool = false
    @State private var goBackToHomepage: Bool = false
    
    init(doctor: DoctorModel) {
        self.doctor = doctor
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Select Date and Time")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.backgroundBlue)
                .padding(.top, 30)
                .padding(.bottom)
            
            DoctorCard(doctor: doctor, buttonsHide: true)
                .transformEffect(.init(scaleX: 0.9, y: 0.9))
            
            ScrollView {
                DateTimePicker(pickedDate: $pickedDate)
                    .transformEffect(.init(scaleX: 0.8, y: 0.8))
            }
            
            BottomArrows(visitedNextPage: .constant(false), nextView: EmptyView().toAnyView(), pageNo: 3, buttonText: "Review and Book", withButton: true, destination: ReviewApptView(doctor: self.doctor).toAnyView(), date: $pickedDate)
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
                                    RegistrationStep(true)
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
