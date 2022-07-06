//
//  ShopAnnotation.swift
//  DaeguGoodPriceShop
//
//  Created by Yeongwoo Kim on 2022/07/05.
//

import Foundation
import MapKit

final class ShopAnnotationView: MKAnnotationView {
    static let identifier = "ShopAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
    }
}

final class ShopAnnotation: NSObject, MKAnnotation {
    let category: ShopCategory
    let location: CLLocation
    var coordinate: CLLocationCoordinate2D {
        self.location.coordinate
    }
    
    init(category: ShopCategory, location: CLLocation) {
        self.category = category
        self.location = location
        super.init()
    }
}
