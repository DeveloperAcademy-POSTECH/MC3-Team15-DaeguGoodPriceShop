//
//  ShopAnnotatable.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/07/07.
//

import UIKit

protocol ShopAnnotatable: AnyObject { }

extension ShopAnnotatable {
    func resizedImage(image: UIImage?, width: CGFloat, height: CGFloat) -> UIImage? {
        guard let image = image else { return nil }
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

