//
//  ModalHeight.swift
//  DaeguGoodPriceShop
//
//  Created by Yeongwoo Kim on 2022/07/10.
//

import UIKit

enum ModalHeight{
    case zero
    case minimum
    case median
    case maximum
    case category
    
    var value: CGFloat {
        get {
            switch self {
            case .zero:
                return 0
            case .minimum:
                return 70
            case .median:
                return UIScreen.main.bounds.height / 3
            case .maximum:
                return UIScreen.main.bounds.height - 70
            case .category:
                return UIScreen.main.bounds.height / 2 - 30
            }
        }
    }
}

