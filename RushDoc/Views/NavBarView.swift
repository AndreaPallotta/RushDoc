//
//  NavBarView.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 4/22/21.
//

import SwiftUI

struct NavBarView: View {
    
    @State var selectedTab : Int = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            HomepageView()
                .tabItem {
                    if selectedTab == 0 {
                        Image(systemName: "house.fill") }
                    else {
                        Image(systemName: "house")
                            .onTapGesture {
                                self.selectedTab = 0
                            }
                    }
                    
                }.tag(0)
            
            CalendarView(ascVisits: [], initialMonth: nil)
                .tabItem {
                    if selectedTab == 1 {
                        Image(systemName: "calendar.circle.fill") }
                    else {
                        Image(systemName: "calendar")
                            .onTapGesture {
                                self.selectedTab = 1
                            }
                    }
                    
                }.tag(1)
            
            ProfileView()
                .tabItem {
                    if selectedTab == 2 {
                        Image(systemName: "person.fill") }
                    else {
                        Image(systemName: "person")
                            .onTapGesture {
                                self.selectedTab = 2
                            }
                    }
                }.tag(2)
        }.onAppear() {
            self.selectedTab = 0
        }
    }
}

struct NavBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavBarView()
    }
}
