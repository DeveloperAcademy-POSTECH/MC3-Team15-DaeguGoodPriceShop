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
    
    override init() {
        super.init()
        self.prepareLocationManager()
    }
    
    func configureAutorization() {
        self.locationAuthorizationEvent(self.locationAuthorization)
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
