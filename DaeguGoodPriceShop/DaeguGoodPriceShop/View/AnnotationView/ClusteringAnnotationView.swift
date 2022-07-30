//
//  ClusteringAnnotationView.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/07/07.
//

import MapKit

final class ClusteringAnnotationView: MKAnnotationView {
    static let identifier = "ClusteringAnnotationView"
    override var rightCalloutAccessoryView: UIView? {
        get {
            let clusterAnnotationZoomButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            clusterAnnotationZoomButton.setImage(UIImage(systemName: "plus.magnifyingglass"), for: .normal)
            return  clusterAnnotationZoomButton
        }
        set {}
    }
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10)
        //var rightCalloutAccessoryView = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This method cannot be called.")
    }
    override func prepareForDisplay() {
        super.prepareForDisplay()
        guard let cluster = annotation as? MKClusterAnnotation else { return }
        var numberOfCateringStores: Int = 0
        var numberOfHairdressingShops: Int = 0
        var numberOfLaundryShops: Int = 0
        var numberOfServiceShops: Int = 0
        
        cluster.memberAnnotations.forEach { annotation in
            guard let shopAnnotation = annotation as? ShopAnnotation else { return }
            switch shopAnnotation.shopSubCategory {
            case .hairCut:
                numberOfHairdressingShops += 1
            case .cleaning:
                numberOfLaundryShops += 1
            case .skinCare, .bath:
                numberOfServiceShops += 1
            default:
                numberOfCateringStores += 1
            }
        }
        
        guard let cateringColor = UIColor(named: "CateringStore"),
              let hairdressingColor = UIColor(named: "HairdressingShop"),
              let laundryColor = UIColor(named: "LaundryShop"),
              let serviceColor = UIColor(named: "ServiceShop")
        else {
            return
        }
        
        self.image = self.drawRatio(
            numberToColorTuples: [
                (numberOfCateringStores, cateringColor),
                (numberOfHairdressingShops, hairdressingColor),
                (numberOfLaundryShops, laundryColor),
                (numberOfServiceShops, serviceColor)
            ]
        )
    }
    
    private func drawRatio(numberToColorTuples: [(number: Int, color: UIColor)]) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
        return renderer.image { _ in
            let totalCount = numberToColorTuples.reduce(0){ $0 + $1.number }
            
            var startAngle: Double = 0
            
            for tuple in numberToColorTuples {
                tuple.color.setFill()
                let piePath = UIBezierPath()
                let angle = CGFloat.pi * 2.0 * CGFloat(tuple.number) / CGFloat(totalCount)
                piePath.addArc(
                    withCenter: CGPoint(x: 20, y: 20),
                    radius: 20,
                    startAngle: startAngle,
                    endAngle: startAngle + angle,
                    clockwise: true
                )
                startAngle += angle
                piePath.addLine(to: CGPoint(x: 20, y: 20))
                piePath.close()
                piePath.fill()
            }
            
            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 24, height: 24)).fill()
            
            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black,
                               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13)]
            let text = totalCount > 99 ? "99+" : "\(totalCount)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }
}
