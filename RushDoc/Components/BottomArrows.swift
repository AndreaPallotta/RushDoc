//
//  BottomArrows.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/9/21.
//

import SwiftUI

struct BottomArrows: View {
    private var pageNo: Int
    private var nextView: AnyView
    private var withButton: Bool
    private var destination: AnyView?
    private var buttonText: String = ""
    @State private var goToNext: Bool = false
    @State private var isActive: Bool = false
    @Binding var visitedNextPage: Bool
    @Binding var date: Date
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    init(visitedNextPage: Binding<Bool>, nextView: AnyView, pageNo: Int) {
        self._visitedNextPage = visitedNextPage
        self._date = .constant(Date())
        self.nextView = nextView
        self.pageNo = pageNo
        self.withButton = false
    }
    
    init(visitedNextPage: Binding<Bool>, nextView: AnyView, pageNo: Int, buttonText: String, withButton: Bool, destination: AnyView, date: Binding<Date>) {
        self._visitedNextPage = visitedNextPage
        self._date = date
        self.nextView = nextView
        self.pageNo = pageNo
        self.buttonText = buttonText
        self.withButton = withButton
        self.destination = destination
    }
    
    var body: some View {
        HStack {
            Button(action: {
                if self.pageNo != 0 {
                    self.mode.wrappedValue.dismiss()
                }
            }, label: {
                Image(systemName: "arrow.left.circle")
                    .resAndFit
                    .square(50)
                    .style(self.pageNo == 0 ? .thin : .bold)
                    .foregroundColor(self.pageNo == 0 ? Color.arrowRed.opacity(0.38) : .arrowRed)
                    .disabled(self.pageNo == 0)
                    .padding(.leading, 30)
            })
            
            if withButton {
                Spacer()
                
                NavigationLink(destination: self.destination, isActive: $isActive) {
                    BackgroundButtonStroke(text: self.buttonText, action: {
                        UserDefaults.standard.set(self.date, forKey: "appt_date")
                        self.isActive.toggle()
                    })
                }.disabled(self.destination == nil)
                Spacer()
            } else {
                Spacer()
            }
            
            
            NavigationLink(
                destination: self.nextView,
                isActive: self.$goToNext,
                label: {
                    Button(action: {
                        self.goToNext = true && self.visitedNextPage && pageNo != 4
                    }, label: {
                        Image(systemName: "arrow.right.circle")
                            .resAndFit
                            .square(50)
                            .style(self.visitedNextPage && self.pageNo != 4 ? .bold : .regular)
                            .foregroundColor(!self.visitedNextPage || self.pageNo == 4 ? Color.arrowRed.opacity(0.38) : .arrowRed)
                            .disabled(!self.visitedNextPage || self.pageNo == 4)
                            .padding(.trailing, 30)
                    })
                })
        }
    }
}
