//
//  Shop.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/06/29.
//

import Foundation
import CoreLocation

struct Shop: Codable, Hashable {
    let serialNumber: Int
    let category: String
    let shopName: String
    let ownerName: String
    let country: String
    let address: String
    let latitude: Double
    let longitude: Double
    let phoneNumber: String
    let menu: String
    let price: String
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
