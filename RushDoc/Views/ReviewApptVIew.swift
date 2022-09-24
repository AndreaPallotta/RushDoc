//
//  ReviewApptVIew.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/11/21.
//

import SwiftUI
import ToastUI

struct ReviewApptView: View {
    
    @State private var showAlert: Bool = false
    @State private var goBackToHomepage: Bool = false
    @State private var dateString: String = ""
    @State private var activeAlert: ActiveAlert = .toHomepage
    @State private var activeToast: ActiveToast = .error
    @State private var showErrorToast: Bool = false
    private var doctor: DoctorModel
    
    init(doctor: DoctorModel) {
        self.doctor = doctor
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                Text("Review And Book")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.backgroundBlue)
                    .padding(.top, 30)
                    .padding(.bottom)
                
                DoctorCard(doctor: doctor, buttonsHide: true)
                
                Text("Appointment For")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.backgroundBlue)
                    .padding([.top, .bottom])
                
                ReviewCard(text: UserDefaults.standard.string(forKey: "appt_user_name") ?? "", image: Image("placeholder_user"))
                
                Text("Category")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.backgroundBlue)
                    .padding([.top, .bottom])
                
                ReviewCard(text: UserDefaults.standard.string(forKey: "appt_category") ?? "", image: Image("orthopedics"))
                
                Text("Date and Time")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.backgroundBlue)
                    .padding([.top, .bottom])
                
                ReviewCard(text: self.dateString)
                
                NavigationLink(
                    destination: HomepageView().toAnyView(),
                    isActive: $goBackToHomepage,
                    label: {
                        BackgroundButtonStroke(text: "Confirm Appointment", action: {
                            self.activeAlert = .confirmAppointment
                            self.showAlert = true
                        })
                    })
                    .padding(.top)
            }
            .padding(.bottom, 10)
            
            Spacer()
            
            BottomArrows(visitedNextPage: .constant(false), nextView: EmptyView().toAnyView(), pageNo: 4)
                .padding(.bottom)
            
        }
        .navigationBarItems(leading:
                                NavigationLink(
                                    destination: HomepageView().toAnyView(),
                                    isActive: $goBackToHomepage,
                                    label: {
                                        Button(action: {
                                            self.activeAlert = .toHomepage
                                            self.showAlert = true
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
                                    RegistrationStep(true)
                                }
                                .padding(.trailing, 30)
        )
        .alert(isPresented: $showAlert, content: {
            switch activeAlert {
                case .toHomepage:
                    return Alert(
                        title: Text("Are you sure you want to go back to the main menu?"),
                        message: Text("Your appointment draft will be deleted permanently."),
                        primaryButton: .destructive(Text("Go to Homepage")) {
                            self.goBackToHomepage = true
                        },
                        secondaryButton: .cancel())
                    
                case .confirmAppointment:
                    return  Alert(
                        title: Text("Successfully booked an appointment!"),
                        message: Text("Do you want to add it to your calendar?"),
                        primaryButton: .destructive(Text("Add to calendar")) {
                            let uId = UserDefaults.standard.integer(forKey: "user_id")
                            if (DBManager().addAppt(uIdValue: Int64(uId), descriptionValue: "Appointment with \(self.doctor.name)", dateValue: UserDefaults.standard.object(forKey: "appt_date") as! Date)) {
                                self.activeToast = .success
                            } else {
                                self.activeToast = .error
                            }
                            self.showErrorToast = true
                        },
                        secondaryButton: .cancel())
            }
        })
        .onAppear(perform: {
            let dateFormatter = DateFormatter().reviewDateTime
            self.dateString = dateFormatter.string(from: UserDefaults.standard.object(forKey: "appt_date") as! Date)
        })
        
        .toast(isPresented: $showErrorToast, dismissAfter: 1.0, content: {
            switch activeToast {
                case .error:
                    ToastView("You already have an appointment at this time.\nChange and try again")
                        .toastViewStyle(ErrorToastViewStyle())

                case .success:
                    ToastView("Successfully added appointment to calendar!")
                        .toastViewStyle(SuccessToastViewStyle())
                        .onDisappear {
                            self.goBackToHomepage = true
                        }
            }
            
        })
        .frame(width: UIScreen.screenWidth)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("")
    }
}

enum ActiveAlert {
    case toHomepage, confirmAppointment
}

enum ActiveToast  {
    case success, error
}

struct ReviewCard: View {
    
    private var text: String
    private var image: Image?
    
    init(text: String) {
        self.text = text
    }
    
    init(text: String, image: Image) {
        self.text = text
        self.image = image
    }
    
    var body: some View {
        HStack {
            if self.image != nil {
                self.image?
                    .resAndFit
                    .square(70)
                
                Text("\(self.text)")
                    .font(.title2)
                    .foregroundColor(.backgroundBlue)
                
                Spacer()
                
            } else {
                Text("\(self.text)")
                    .font(.title2)
                    .foregroundColor(.backgroundBlue)
                    .padding([.top, .bottom])
            }
        }
        .padding(10)
        .frame(maxWidth: UIScreen.screenWidth - 30)
        .overlay (
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.lightGray, lineWidth: 3.0)
        )
        .modifier(CardModifier(cornerRadius: 15))
    }
}
