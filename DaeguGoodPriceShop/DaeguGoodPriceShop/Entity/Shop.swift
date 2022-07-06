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
    let subcategory: String
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

extension Shop {
    func getCategory() -> ShopCategory? {
        switch self.subcategory {
        case "한식", "중식", "양식", "분식", "제과", "일식", "카페":
            return .restaurant
            
        case "미용":
            return .hair
            
        case "세탁":
            return .laundry
            
        case "피부미용":
            return .beauty
            
        case "목욕":
            return .bath
            
        default:
            return nil
        }
    }
}
