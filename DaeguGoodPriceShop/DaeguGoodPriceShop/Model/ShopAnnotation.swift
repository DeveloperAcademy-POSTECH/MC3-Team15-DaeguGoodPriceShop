//
//  ShopAnnotation.swift
//  DaeguGoodPriceShop
//
//  Created by Yeongwoo Kim on 2022/07/05.
//

import MapKit

final class ShopAnnotation: NSObject, MKAnnotation {
    let shop: Shop
    var serialNumber: Int {
        shop.serialNumber
    }
    let title: String?
    let subtitle: String?
    let shopSubCategory: ShopSubCategory
    var latitude: Double {
        shop.latitude
    }
    var longitude: Double {
        shop.longitude
    }
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init?(of shop: Shop) {
        guard let shopSubCategory = shop.shopSubCategory else { return nil }
        self.shop = shop
        self.title = shop.shopName
        self.subtitle = shop.menu
        self.shopSubCategory = shopSubCategory
        super.init()
    }
}
