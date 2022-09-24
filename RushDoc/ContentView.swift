//
//  ContentView.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 2/10/21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        LandingView()
        //CalendarView(ascVisits: Visit.mocks(start: .daysFromToday(-365*2), end: .daysFromToday(365*2)), initialMonth: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
