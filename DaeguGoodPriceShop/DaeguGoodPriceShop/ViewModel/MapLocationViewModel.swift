//
//  MapLocationViewModel.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/07/27.
//

import Foundation
import CoreLocation
import Combine

final class MapLocationViewModel {
    @Published private(set) var locationAutorization: Bool = false
    @Published private(set) var initialLocation: CLLocation?
    private let locationManager: LocationManager
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        configureBindings()
        configureLocationManager()
    }
    
    private func configureBindings() {
        locationManager.locationAuthorizationEvent = { [weak self] bool in
            self?.locationAutorization = bool
        }
        locationManager.initialLocationEvent = { [weak self] location in
            self?.initialLocation = location
        }
    }
    
    private func configureLocationManager() {
        locationManager.configureAutorization()
    }
}
