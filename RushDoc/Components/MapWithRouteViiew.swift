//
//  MapWithRouteViiew.swift
//  RushDoc
//
//  Created by Andrea Pallotta on 5/10/21.
//

import SwiftUI
import MapKit
import UIKit

struct MapWithRouteView: View {
    
    @State private var directions: [String] = []
    @State private var showDirections = false
    @ObservedObject var locationManager = LocationManager()
    private var userLocation: CLLocationCoordinate2D
    private var doctor: DoctorModel
    
    init(doctor: DoctorModel) {
        self.doctor = doctor
        self.userLocation = CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "user_lat"), longitude: UserDefaults.standard.double(forKey: "user_long"))
    }
    
    var body: some View {
        VStack {
            VStack {
                MapView(userLocation: self.userLocation, doctorLocation: CLLocationCoordinate2D(latitude: self.doctor.lat, longitude: self.doctor.long), directions: $directions)
                    .cornerRadius(15)
                
                BackgroundButtonStroke(text: "Show Directiions", action: {self.showDirections.toggle()})
                    .disabled(directions.isEmpty)
                    .padding()
            }
            .padding(10)
        }
        .background(Color.white)
        .frame(maxWidth: UIScreen.screenWidth - 30, maxHeight: 300)
        .overlay (
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.lightGray, lineWidth: 3.0)

        )
        .modifier(CardModifier(cornerRadius: 15))
        .sheet(isPresented: $showDirections, content: {
            VStack(spacing: 0) {
                Text("Directions")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.backgroundBlue)
                
                Divider()
                    .padding([.leading, .trailing])
                
                List(0..<self.directions.count, id: \.self) { index in
                    Text(self.directions[index]).padding()
                }
            }
        })
    }
}

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    var userLocation: CLLocationCoordinate2D
    var doctorLocation: CLLocationCoordinate2D
    
    @Binding var directions: [String]
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let region = MKCoordinateRegion(
            center: self.userLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        mapView.setRegion(region, animated: true)
        let userPM = MKPlacemark(coordinate: self.userLocation)
        let doctorPM = MKPlacemark(coordinate: self.doctorLocation)
        
        /// https://medium.com/swlh/swiftui-tutorial-finding-a-route-and-directions-52b973530f8d  for how to get directions
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPM)
        request.destination = MKMapItem(placemark: doctorPM)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            mapView.addAnnotations([userPM, doctorPM])
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                animated: true)
            self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
        }
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
    }
}
