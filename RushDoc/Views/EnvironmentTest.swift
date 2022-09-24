//
//  EnvironmentTest.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 2/12/21.
//
import SwiftUI
// Our observable object class
class UserSettings: ObservableObject {
    @Published var score = 0
}

// A view that expects to find a UserSettings object
// in the environment, and shows its score.
struct DetailView: View {
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        Text("Score: \(settings.score)")
    }
}

// A view that creates the UserSettings object,
// and places it into the environment for the
// navigation view.
struct TestContentView: View {
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        NavigationView {
            VStack {
                // A button that writes to the environment settings
                Button("Increase Score") {
                    settings.score += 1
                }

                NavigationLink(destination: DetailView()) {
                    Text("Show Detail View")
                }
            }
        }
    }
}
