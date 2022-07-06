//
//  MapViewController+.swift
//  DaeguGoodPriceShop
//
//  Created by Yeongwoo Kim on 2022/07/06.
//

import Foundation
import UIKit
import MapKit

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ShopAnnotation else {
            return nil
        }
        
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: ShopAnnotationView.identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: ShopAnnotationView.identifier)
            annotationView?.canShowCallout = false
            annotationView?.contentMode = .scaleAspectFit
        } else {
            annotationView?.annotation = annotation
        }
        
        let annotationImage: UIImage!
        let size = CGSize(width: 30, height: 30)
        UIGraphicsBeginImageContext(size)
        
        //TODO: Annotation Image 추가
        switch annotation.category {
        case .restaurant:
            annotationImage = UIImage(systemName: "book")?.withTintColor(.red)
        case .hair:
            annotationImage = UIImage(systemName: "doc")?.withTintColor(.blue)
        case .laundry:
            annotationImage = UIImage(systemName: "paperplane")?.withTintColor(.orange)
        case .beauty:
            annotationImage = UIImage(systemName: "trash")?.withTintColor(.yellow)
        case .bath:
            annotationImage = UIImage(systemName: "swift")?.withTintColor(.purple)
        }
        
        annotationImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView?.image = resizedImage
        
        return annotationView
    }
}
