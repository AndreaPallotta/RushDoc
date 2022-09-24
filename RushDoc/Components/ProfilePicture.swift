//
//  ProfilePicture.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/8/21.
//

import SwiftUI

struct ProfilePicture : View {
    
    @Binding var profilePic: Image?
    @State private var isImagePicker = false
    @State private var isActionSheet = false
    @State private var isCamera = false
    
    var body : some View {
        VStack {
            profilePic!
                .resAndFit
                .clipShape(Circle())
                .shadow(radius: 10)
                .overlay(Circle().stroke(Color.darkGray, lineWidth: 3))
                .onTapGesture { self.isActionSheet = true }
                .sheet(isPresented: $isImagePicker) {
                                ImagePicker(sourceType: self.isCamera ? .camera : .photoLibrary, image: self.$profilePic, isPresented: self.$isImagePicker)
                }
                .actionSheet(isPresented: $isActionSheet) { () -> ActionSheet in
                    ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                        self.isImagePicker = true
                        self.isCamera = true
                    }), ActionSheet.Button.default(Text("Photo Library"), action: {
                        self.isImagePicker = true
                        self.isCamera = false
                    }), ActionSheet.Button.cancel()])
                }
        }
    }
}
