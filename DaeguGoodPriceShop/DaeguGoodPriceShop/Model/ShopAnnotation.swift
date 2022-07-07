//
//  ShopAnnotation.swift
//  DaeguGoodPriceShop
//
//  Created by Yeongwoo Kim on 2022/07/05.
//

import MapKit

final class ShopAnnotation: NSObject, MKAnnotation {
    let shopSubCategory: ShopSubCategory
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocation(latitude: latitude, longitude: longitude).coordinate
    }
    
    init(shopSubCategory: ShopSubCategory, latitude: Double, longitude: Double) {
        self.shopSubCategory = shopSubCategory
        self.latitude = latitude
        self.longitude = longitude
        super.init()
    }
}
