
import Foundation
import CoreLocation
import Combine
import MapKit


class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    let objectWillChange = PassthroughSubject<Void,Never>()
    
    @Published var locationError: Bool? {
        willSet {objectWillChange.send()}
    }
    
    @Published var permissionsError: Bool? {
        willSet {objectWillChange.send()}
    }
    
    @Published var status: CLAuthorizationStatus? {
        willSet {objectWillChange.send()}
    }
    
    @Published var location: CLLocation? {
        willSet {objectWillChange.send()}
    }
    
    override init() {
        super.init()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @Published var placemark: CLPlacemark? {
        willSet {objectWillChange.send()}
    }
    
    private func geocode() {
        guard let location = location else {return}
        geocoder.reverseGeocodeLocation(location) { (places, error) in
            if error == nil {
                self.placemark = places?[0]
            } else {
                self.placemark = nil
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        status = manager.authorizationStatus
        switch status {
        case .restricted:
            self.permissionsError = true
            return
        case .denied:
            self.permissionsError = true
            return
        case .notDetermined:
            self.permissionsError = true
            return
        case .authorizedWhenInUse:
            self.permissionsError = false
            return
        case .authorizedAlways:
            self.permissionsError = false
            return
        case .none:
            self.permissionsError = true
            return
        @unknown default:
            break
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        self.location = location
        self.locationError = false
        self.geocode()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationError = true
    }
}










