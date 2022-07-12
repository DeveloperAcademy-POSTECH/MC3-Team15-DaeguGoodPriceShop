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
    let serialNumber: Int
    let title: String?
    let subtitle: String?
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init?(of shop: Shop) {
        guard let shopSubCategory = shop.shopSubCategory else { return nil }
        self.shopSubCategory = shopSubCategory
        self.latitude = shop.latitude
        self.longitude = shop.longitude
        self.serialNumber = shop.serialNumber
        self.title = shop.shopName
        self.subtitle = shop.menu
        super.init()
    }
}
