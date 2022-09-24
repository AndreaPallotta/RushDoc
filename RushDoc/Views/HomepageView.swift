//
//  HomepageView.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 3/29/21.
//

import SwiftUI
import UIKit
import CoreLocation
import QGrid

struct HomepageView: View {
    
    @ObservedObject var locationManager = LocationManager()
    @State private var triggerAddressDropDown: Bool = false
    @State private var IsNotifications: Bool = false
    @State private var searchBarText: String = ""
    @State private var address: String?
    @State private var userModels: [DBUserModel] = []
    
    private var cards: [Card]
    var locationError : Bool {
        locationManager.locationError ?? false
    }
    
    func goToDeviceSettings() {
      guard let url = URL.init(string: UIApplication.openSettingsURLString) else { return }
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    init() {

        self.cards = [
            Card(image: "doctor", title: "Doctors", subtitle: "Find doctors near you", destination: DoctorApptRegistrationView().toAnyView()),
            Card(image: "pills", title: "Medicines", subtitle: "Check pharmacies"),
            Card(image: "test_tube", title: "Lab Test", subtitle: "Book medical tests"),
            Card(image: "chat", title: "Chat", subtitle: "Chat with doctors"),
            Card(image: "audio_call", title: "Audio Call", subtitle: "Request phone calls"),
            Card(image: "video_call", title: "Video Call", subtitle: "Request video calls")
        ]
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    VStack {
                        HStack {
                            Image(systemName: "location")
                                .foregroundColor(.backgroundBlue)
                            Text("Your Address")
                                .font(.title2)
                                .foregroundColor(.backgroundBlue)
                                .bold()
                        }
                        .padding(.bottom, 5)
                        
                        Text("\(UserDefaults.standard.string(forKey: "user_address") ?? "No Address Found. Refresh to try again")")
                            .font(.caption)
                            .lineLimit(1)
                            .allowsTightening(true)
                            .truncationMode(.tail)
                            .foregroundColor(.gray)
                    }
                }
                .padding(10)
                
                HStack {
                    SearchBar(text: $searchBarText)
                    Spacer()
                    Button(action: {
                        IsNotifications.toggle()
                    }, label: {
                        if IsNotifications {
                            Image(systemName: "bell.circle.fill").font(.system(size: 30))
                        } else {
                            Image(systemName: "bell.circle").font(.system(size: 30))
                        }
                    })
                    .sheet(isPresented: $IsNotifications, content: {
                        VStack {
                            Text("Your Notifications")
                                .foregroundColor(.black)
                                .font(.title)
                                .bold()
                                .padding(.top, 30)
                                .padding(.bottom, 30)
                            
                            Text("You have no notifications at the moment")
                                .foregroundColor(.gray)
                                .font(.title3)
                            
                            Spacer()
                        }
                    })
                    
                }.padding(.bottom)
                
                QGrid(cards,
                      columns: 2,
                      vSpacing: 20,
                      hSpacing: 10) {
                    CategoryCard(card: $0)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .padding(.leading, 10)
            .padding(.trailing, 10)
            .onAppear(perform: {
                self.userModels = DBManager().getUsers()
                address = self.locationManager.placemark?.mailingAddress

                if (address != nil) {
                    UserDefaults.standard.set(address?.newLines.joined(separator: ", "), forKey: "user_address")
                }
                if self.locationManager.location?.coordinate != nil {
                    UserDefaults.standard.set(Double(self.locationManager.location?.coordinate.latitude ?? 43.0845), forKey: "user_lat")
                    UserDefaults.standard.set(Double(self.locationManager.location?.coordinate.longitude ?? -77.6749), forKey: "user_long")
                }
            })
            .hiddenNavigationBarStyle()
            .alert(isPresented: .constant(locationError), content: {
                Alert(title: Text("Location Access Denied"), message: Text("Your location is needed"), primaryButton: .cancel(), secondaryButton: .default(Text("Settings"), action: {self.goToDeviceSettings()}))
            })
            
            
        }
        .hiddenNavigationBarStyle()
        
    }
}
