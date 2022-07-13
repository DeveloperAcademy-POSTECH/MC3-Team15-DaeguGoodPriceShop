//
//  ModalHeight.swift
//  DaeguGoodPriceShop
//
//  Created by Yeongwoo Kim on 2022/07/10.
//

import UIKit

enum ModalHeight{
    case zero
    case median
    case maximum
    
    var value: CGFloat {
        get {
            switch self {
            case .zero:
                return 0
            case .median:
                return UIScreen.main.bounds.height / 2
            case .maximum:
                return UIScreen.main.bounds.height - 70
            }
        }
    }
}

