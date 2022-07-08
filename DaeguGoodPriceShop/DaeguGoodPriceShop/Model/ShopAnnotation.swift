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
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(shopSubCategory: ShopSubCategory, latitude: Double, longitude: Double) {
        self.shopSubCategory = shopSubCategory
        self.latitude = latitude
        self.longitude = longitude
        super.init()
    }
}
