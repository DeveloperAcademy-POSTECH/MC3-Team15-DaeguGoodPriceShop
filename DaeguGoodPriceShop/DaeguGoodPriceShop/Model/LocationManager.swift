//
//  LocationManager.swift
//  DaeguGoodPriceShop
//
//  Created by Yeongwoo Kim on 2022/07/05.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
    private let manager = CLLocationManager()
    private var locationAuthorization: Bool {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        default :
            return false
        }
    }
    var locationAuthorizationEvent: (Bool) -> Void = { _ in }
    var initialLocationEvent: (CLLocation) -> Void = { _ in }
    var locationManager: CLLocationManager!
    var myLatitude: Double?
    var myLongitude: Double?
    
    override init() {
        super.init()
        self.prepareLocationManager()
        locationManager = CLLocationManager()
        let coor = locationManager.location?.coordinate
        myLatitude = coor?.latitude ?? 0.0
        myLongitude = coor?.longitude ?? 0.0
    }
    
    func configureAutorization() {
        self.locationAuthorizationEvent(self.locationAuthorization)
    }
    
    func calDistance(latitude: Double?, longitude: Double?) -> Double {
        guard let latitude = latitude, let longitude = longitude else {
            return 0.0
        }
        let myLocation = CLLocation(latitude: myLatitude ?? 0.0, longitude: myLongitude ?? 0.0)
        let myShopLocation = CLLocation(latitude: latitude, longitude: longitude)
        let distance = myLocation.distance(from: myShopLocation) / 1000
        return distance
    }
    
    private func prepareLocationManager() {
        self.manager.delegate = self
        self.manager.requestWhenInUseAuthorization()
        self.manager.requestAlwaysAuthorization()
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.initialLocationEvent(location)
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.locationAuthorizationEvent(self.locationAuthorization)
    }
}
