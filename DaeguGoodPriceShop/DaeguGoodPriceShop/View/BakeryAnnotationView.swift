//
//  BakeryAnnotationView.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/07/07.
//

import MapKit

final class BakeryAnnotationView: MKAnnotationView, ShopAnnotatable {
    static let identifier = "BakeryAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        self.image = resizedImage(image: UIImage(named: "bakery"), width: 40, height: 40)
    }
}
