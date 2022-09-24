//
//  ProfileContentCard.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/8/21.
//

import SwiftUI

struct ProfileContentCard: View {
    
    private var title: String
    private var titleIcon: Image
    private var fields: [ProfileFieldModel]
    
    init (title: String, titleIcon: Image, fields: [ProfileFieldModel]) {
        self.title = title
        self.titleIcon = titleIcon
        self.fields = fields
    }
     
    var body: some View {
        VStack {
            HStack {
                self.titleIcon
                    .resAndFit
                    .square(30)
                    .style(.bold)
                    .foregroundColor(.backgroundBlue)
                    .padding(.trailing, 10)
                
                Text(self.title)
                    .font(.title)
                    .bold()
                    .foregroundColor(.backgroundBlue)
                    .fitInLine(lines: 1)
                    
                Spacer()
            }
            .padding(.leading)
            
            ForEach(self.fields, id:\.id) { field in
                ProfileContentRow(text: field.name, icon: field.image, destination: field.destination)
            }
            
        }
        .frame(maxWidth: UIScreen.screenWidth - 30)
        .padding([.top, .bottom], 30)
        .overlay (
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.lightGray, lineWidth: 3.0)
        )
        .background(Color.white)
        .modifier(CardModifier(cornerRadius: 15))
    }
}

struct ProfileContentRow: View {
    
    private var icon: Image
    private var text: String
    private var destination: AnyView?
    
    init(text: String, icon: Image, destination: AnyView?) {
        self.text = text
        self.icon = icon
        self.destination = destination
    }
    
    init(text: String, icon: Image) {
        self.text = text
        self.icon = icon
    }
    
    
    var body: some View {
        NavigationLink(
            destination: self.destination,
            label: {
                HStack {
                    self.icon
                        .resAndFit
                        .square(25)
                        .style(.thin)
                        .foregroundColor(.backgroundBlue)
                        .padding(.trailing, 10)
                    
                    Text(self.text)
                        .font(.title2)
                        .foregroundColor(.backgroundBlue)
                        .fitInLine(lines: 1)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .resAndFit
                        .square(15)
                        .style(.light)
                        .foregroundColor(.backgroundBlue)
                        .padding(.trailing)
                }
                .padding(.leading)
                .padding(.top, 10)
            })
            .disabled(self.destination == nil)
    }
}

struct ProfileContentCard_Previews: PreviewProvider {
    static var previews: some View {
        ProfileContentCard(title: "Personal Information", titleIcon: Image(systemName: "gearshape"), fields: [ProfileFieldModel(name: "Manage my account", destination: EmptyView().toAnyView(), image: Image(systemName: "person")), ProfileFieldModel(name: "Manage my account", destination: EmptyView().toAnyView(), image: Image(systemName: "star"))])
    }
}
