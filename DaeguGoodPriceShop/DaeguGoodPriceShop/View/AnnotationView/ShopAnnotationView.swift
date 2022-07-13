//
//  ShopAnnotationView.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/07/08.
//

import MapKit

class ShopAnnotationView: MKAnnotationView {
    static var identifier: String {
        return String(describing: self)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = true
        self.calloutOffset = CGPoint(x: 0, y: -5)
//        self.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        self.centerOffset = CGPoint(x: 0, y: 0)
    }
    
    func resizedImage(image: UIImage?, width: CGFloat, height: CGFloat) -> UIImage? {
        guard let image = image else { return nil }
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func selected() {
        self.centerOffset = CGPoint(x: 0, y: -24.96)
    }
}
