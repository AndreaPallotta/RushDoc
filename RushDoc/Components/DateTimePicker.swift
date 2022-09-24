//
//  DateTimePicker.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/10/21.
//

import SwiftUI


struct DateTimePicker: View {
    
    @Binding var pickedDate: Date
    
    init(pickedDate: Binding<Date>) {
        self._pickedDate = pickedDate
    }
    
    var body: some View {
        VStack(alignment: .center) {
            DatePicker("", selection: $pickedDate, in: Date()...)
                .accentColor(.backgroundBlue)
                .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gradientLightBlue).opacity(0.2))
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
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
