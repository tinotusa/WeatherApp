//
//  LocationManager.swift
//  Weather
//
//  Created by Tino on 28/12/21.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var lastLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error in \(#function).\n\(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        lastLocation = location
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("here authorized")
            locationManager.requestLocation()
        case .notDetermined:
            print("here not determined")
        case .denied:
            print("here denied")
        case .restricted:
            print("here restricted")
        default:
            print("here")
        }
    }
}
