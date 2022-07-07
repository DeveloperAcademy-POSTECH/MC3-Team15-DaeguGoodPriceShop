//
//  SkinCareAnnotationView.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/07/07.
//

import MapKit

final class SkinCareAnnotationView: MKAnnotationView, ShopAnnotatable {
    static let identifier = "SkinCareAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.clusteringIdentifier = "ServiceShop"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            self.clusteringIdentifier = "ServiceShop"
        }
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        self.image = resizedImage(image: UIImage(named: "skinCare"), width: 40, height: 40)
    }
}
