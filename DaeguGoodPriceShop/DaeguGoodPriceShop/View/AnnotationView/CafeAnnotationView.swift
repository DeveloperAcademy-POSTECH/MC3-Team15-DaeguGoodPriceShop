//
//  CafeAnnotationView.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/07/07.
//

import MapKit

final class CafeAnnotationView: MKAnnotationView, ShopAnnotatable {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.clusteringIdentifier = "CateringStore"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            self.clusteringIdentifier = "CateringStore"
        }
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        self.centerOffset = CGPoint(x: 0, y: 0)
        self.image = resizedImage(image: UIImage(named: "cafe"), width: 40, height: 40)
    }
    
    func selected() {
        self.centerOffset = CGPoint(x: 0, y: -24.96)
        self.image = resizedImage(image: UIImage(named: "cafeSelected"), width: 40, height: 49.92)
    }
}
