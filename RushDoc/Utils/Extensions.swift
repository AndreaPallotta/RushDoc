//
//  Extensions.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/7/21.
//

import Foundation
import SwiftUI
import UIKit
import Contacts
import CoreLocation
import ElegantCalendar

extension Binding where Value == Bool {
    var not: Binding<Value> {
        Binding<Value> (
            get: { !self.wrappedValue },
            set: { self.wrappedValue = !$0 }
        )
    }
}

extension StringProtocol {
    var newLines: [SubSequence] {self.split(whereSeparator: \.isNewline)}
}


extension String {
    var charOnly: String {
        return self.trimmingCharacters(in: .letters)
    }
    
    var noPunc: String {
        return self.last!.isPunctuation ? split(whereSeparator: \.isLetter.neg).joined(separator: " ") : self
    }
    
    var trimWS: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix)  { return self }
        return "\(prefix)\(self)"
    }
    
    
}

extension Bool {
    var neg: Bool { !self }
}

extension View {
    func toAnyView() -> AnyView {
        AnyView(self)
    }
    
    func toNavView() -> some View {
        NavigationView { self }
    }
    
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
    
    func square(_ size: CGFloat) -> some View {
        return self.frame(width: size, height: size)
    }
    
    func style(_ weight: Font.Weight = .medium, _ size: CGFloat = 30, _ design: Font.Design = .default) -> some View {
        return self.font(.system(size: size, weight: weight, design: design))
    }
    
    /// https://stackoverflow.com/questions/56490250/dynamically-hiding-view-in-swiftui
    @ViewBuilder func hide(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
    
    func foregroundGradient(colors: [Color], startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors), startPoint: startPoint, endPoint: endPoint))
            .mask(self)
    }
    
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    static let backgroundBlue: Color = Color(hex: Constants.backgroundBlue)
    static let gradientLightBlue: Color = Color(hex: Constants.gradientLightBlue)
    static let lightGray: Color = Color(hex: Constants.lightGray)
    static let darkGray: Color = Color(hex: Constants.darkGray)
    static let textGreen: Color = Color(hex: Constants.textGreen)
    static let arrowRed: Color = Color(hex: Constants.arrowRed)
    static let starYellow: Color = Color(hex: Constants.starYellow)
    
}

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

extension Text {
    func fitInLine(lines: Int) -> some View {
        return self.lineLimit(lines).allowsTightening(true).truncationMode(.tail)
    }
}

extension Image {
    var resAndFit: some View {
        return self.resizable().scaledToFit()
    }
    
    var resAndFill: some View {
        return self.resizable().scaledToFill()
    }
}

extension DateFormatter {
    var reviewDateTime: DateFormatter {
        
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        dateFormatter.dateFormat = "E, d MMM - hh:mm a"
        return dateFormatter
    }
}

extension Date {
    static var tomorrow: Date { return Date().tomorrowDate }
    var tomorrowDate: Date { return Calendar.current.date(byAdding: .day, value: 1, to: todayDate)!}
    var todayDate: Date { return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!}
}

///https://stackoverflow.com/questions/46869394/reverse-geocoding-in-swift-4 (following 4 extensions from accepted answer by Leo Dabus)
extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
    
    var latitude: Double { return self.coordinate.latitude }
    var longitude: Double { return self.coordinate.longitude }
}

extension Formatter {
    static let mailingAddress: CNPostalAddressFormatter = {
        let formatter = CNPostalAddressFormatter()
        formatter.style = .mailingAddress
        return formatter
    }()
}

extension CLPlacemark {
    var mailingAddress: String? {
        return postalAddress?.mailingAddress
    }
}

extension CNPostalAddress {
    var mailingAddress: String {
        return Formatter.mailingAddress.string(from: self)
    }
}


/// https://github.com/ThasianX/ElegantCalendar/tree/master/Example/Example
extension CalendarView: ElegantCalendarDataSource {

    func calendar(backgroundColorOpacityForDate date: Date) -> Double {
        let startOfDay = currentCalendar.startOfDay(for: date)
        return Double((visitsByDay[startOfDay]?.count ?? 0) + 3) / 15.0
    }

    func calendar(canSelectDate date: Date) -> Bool {
        let day = currentCalendar.dateComponents([.day], from: date).day!
        return day != 4
    }

    func calendar(viewForSelectedDate date: Date, dimensions size: CGSize) -> AnyView {
        let startOfDay = currentCalendar.startOfDay(for: date)
        return VisitsListView(visits: visitsByDay[startOfDay] ?? [], height: size.height).erased
    }
    
}

extension CalendarView: ElegantCalendarDelegate {

    func calendar(didSelectDay date: Date) {}
    func calendar(willDisplayMonth date: Date) {}
    func calendar(didSelectMonth date: Date) {}
    func calendar(willDisplayYear date: Date) {}

}

extension Date {

    static func daysFromToday(_ days: Int) -> Date {
        Date().addingTimeInterval(TimeInterval(60*60*24*days))
    }
    
    static func hoursFromToday(_ hours: Int) -> Date {
        Date().addingTimeInterval(TimeInterval(60*60*hours))
    }
    
    var fullDate: String {
        DateFormatter.fullDate.string(from: self)
    }

    var timeOnlyWithPadding: String {
        DateFormatter.timeOnlyWithPadding.string(from: self)
    }
    
    func compare(_ date2: Date, _ component: Calendar.Component = .calendar) -> Bool {
        return Calendar.current.component(component, from: self) == Calendar.current.component(component, from: date2)
    }
    
    func hoursFromDate(_ hours: Int = 1) -> Date {
        return self.addingTimeInterval(TimeInterval(60 * 60 * hours))
    }

}

extension DateFormatter {

    static var fullDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter
    }

    static let timeOnlyWithPadding: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()

}






