//
//  ShopAnnotatable.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/07/07.
//

import UIKit

protocol ShopAnnotatable: AnyObject { }

extension ShopAnnotatable {
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    func resizedImage(image: UIImage?, width: CGFloat, height: CGFloat) -> UIImage? {
        guard let image = image else { return nil }
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

