//
//  HairCutAnnotationView.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/07/07.
//

import MapKit

final class HairCutAnnotationView: MKAnnotationView, ShopAnnotatable {
    static let identifier = "HairCutAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.clusteringIdentifier = "HairdressingShop"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            self.clusteringIdentifier = "HairdressingShop"
        }
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        self.image = resizedImage(image: UIImage(named: "hairCut"), width: 40, height: 40)
    }
}
