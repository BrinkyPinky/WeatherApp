//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Егор Шилов on 30.08.2022.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate  {    
    let manager = CLLocationManager()
    
    static var shared = LocationManager()
    
    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.requestAlwaysAuthorization()
    }
    
    func getUserLocation(completion: @escaping (LocationModel?) -> Void) {
        manager.requestLocation()
        completion(LocationModel(
            longitude: manager.location?.coordinate.longitude,
            latitude: manager.location?.coordinate.latitude
        ))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if locations.first != nil {
            print("location:: (location)")
        }

    }
}
