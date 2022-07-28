//
//  MapLocationViewModel.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/07/27.
//

import Foundation
import CoreLocation

final class MapLocationViewModel {
    private let locationManager: LocationManager
    var locationAuthorizationEvent: (Bool) -> Void = { _ in }
    var initialLocationEvent: (CLLocation) -> Void = { _ in }
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        configureBindings()
        configureLocationManager()
    }
    
    private func configureBindings() {
        locationManager.locationAuthorizationEvent = { [weak self] bool in
            self?.locationAuthorizationEvent(bool)
        }
        locationManager.initialLocationEvent = { [weak self] location in
            self?.initialLocationEvent(location)
        }
    }
    
    private func configureLocationManager() {
        locationManager.configureAutorization()
    }
}
