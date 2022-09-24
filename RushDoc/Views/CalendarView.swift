//
//  CalendarView.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 4/22/21.
//

import SwiftUI
import ElegantCalendar
import ToastUI

struct CalendarView: View {

    @State private var show: Bool = false
    @State private var calendarTheme: CalendarTheme = .royalBlue
    @ObservedObject var calendarManager: ElegantCalendarManager
    
    var startDate = Date().addingTimeInterval(TimeInterval(1 * 24 * (-30 * 36)))
    var endDate = Date().addingTimeInterval(TimeInterval(15 * 60 * 24 * (30 * 36)))
    
    var visitsByDay: [Date: [Visit]] = Dictionary()
    
    var visits: [Visit] = []
    
    init(ascVisits: [Visit], initialMonth: Date?) {
        
        let configuration = CalendarConfiguration(
            calendar: currentCalendar,
            startDate: ascVisits.first?.arrivalDate ?? Date().addingTimeInterval(TimeInterval(1 * 24 * (-30 * 36))),
            endDate: ascVisits.last?.arrivalDate ?? Date().addingTimeInterval(TimeInterval(15 * 60 * 24 * (30 * 36))))

        calendarManager = ElegantCalendarManager(
            configuration: configuration,
            initialMonth: initialMonth)
        
        toArray(DBManager().getApptsByUID(uIdValue: Int64(UserDefaults.standard.integer(forKey: "user_id"))))
        
        visitsByDay = Dictionary(
            grouping: visits,
            by: { currentCalendar.startOfDay(for: $0.arrivalDate) })

        calendarManager.datasource = self
        calendarManager.delegate = self
    }
    
    mutating func toArray(_ appts: [DBApptModel]) {
        appts.forEach { appt in
            visits.append(Visit(description: appt.description, arrivalDate: appt.date, departureDate: Date()))
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ElegantCalendarView(calendarManager: calendarManager)
                    .theme(calendarTheme)
            }
        }
        .hiddenNavigationBarStyle()
    }
    
}
