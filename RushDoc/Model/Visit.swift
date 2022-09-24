//
//  Visit.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/11/21.
//  Code tutorial: https://github.com/ThasianX/ElegantCalendar
//

import Foundation
import SwiftUI
import ElegantCalendar


let currentCalendar = Calendar.current
let screen = UIScreen.main.bounds

struct Visit {
    
    let description: String
    let arrivalDate: Date
    let departureDate: Date
    
    init(description: String, arrivalDate: Date, departureDate: Date) {
        self.description = description
        self.arrivalDate = arrivalDate
        self.departureDate = departureDate
    }
    
    var duration: String {
        arrivalDate.timeOnlyWithPadding + " ➝ " + arrivalDate.hoursFromDate().timeOnlyWithPadding
    }
    
}

extension Visit: Identifiable {
    var id: Int {
        UUID().hashValue
    }
}


struct VisitCell: View {
    
    let visit: Visit
    
    var body: some View {
        HStack {
            tagView
            
            VStack(alignment: .leading) {
                description
                visitDuration
            }
            
            Spacer()
        }
        .frame(height: VisitPreviewConstants.cellHeight)
        .padding(.vertical, VisitPreviewConstants.cellPadding)
    }
    
}

private extension VisitCell {
    
    var tagView: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.backgroundBlue)
            .frame(width: 5, height: 30)
    }
    
    var description: some View {
        Text(visit.description)
            .font(.system(size: 16))
            .lineLimit(1)
    }
    
    var visitDuration: some View {
        Text(visit.duration)
            .font(.system(size: 10))
            .lineLimit(1)
    }
    
}

struct VisitPreviewConstants {
    
    static let cellHeight: CGFloat = 30
    static let cellPadding: CGFloat = 10
    
    static let previewTime: TimeInterval = 3
    
}

struct VisitsListView: View {
    
    private let timer = Timer.publish(every: VisitPreviewConstants.previewTime,
                                      on: .main, in: .common).autoconnect()
    @State var visitIndex = 0
    
    let visits: [Visit]
    let numberOfCellsInBlock: Int
    
    init(visits: [Visit], height: CGFloat) {
        self.visits = visits
        numberOfCellsInBlock = Int(height / (VisitPreviewConstants.cellHeight + VisitPreviewConstants.cellPadding*2))
    }
    
    private var range: Range<Int> {
        let exclusiveEndIndex = visitIndex + numberOfCellsInBlock
        guard visits.count > numberOfCellsInBlock &&
                exclusiveEndIndex <= visits.count else {
            return visitIndex..<visits.count
        }
        return visitIndex..<exclusiveEndIndex
    }
    
    var body: some View {
        visitsPreviewList
            .animation(.easeInOut)
            .onAppear(perform: setUpVisitsSlideShow)
            .onReceive(timer) { _ in
                self.shiftActivePreviewVisitIndex()
            }
    }
    
    private func setUpVisitsSlideShow() {
        if visits.count <= numberOfCellsInBlock {
            timer.upstream.connect().cancel()
        }
    }
    
    private func shiftActivePreviewVisitIndex() {
        let startingVisitIndexOfNextSlide = visitIndex + numberOfCellsInBlock
        let startingVisitIndexOfNextSlideIsValid = startingVisitIndexOfNextSlide < visits.count
        visitIndex = startingVisitIndexOfNextSlideIsValid ? startingVisitIndexOfNextSlide : 0
    }
    
    private var visitsPreviewList: some View {
        VStack(spacing: 0) {
            ForEach(visits[range]) { visit in
                VisitCell(visit: visit)
            }
        }
    }
    
}



