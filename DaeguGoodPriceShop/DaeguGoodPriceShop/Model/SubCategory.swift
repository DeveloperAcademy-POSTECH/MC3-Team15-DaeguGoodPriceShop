//
//  SubCategory.swift
//  DaeguGoodPriceShop
//
//  Created by 정재윤 on 2022/07/13.
//

import UIKit

class SubCategory {
    private let identifier = UUID()
    
    let shopSubCategory: ShopSubCategory?
    var categoryColor: UIColor? {
        switch self.shopSubCategory {
        case .koreanFood, .chineseFood, .westernFood, .japaneseFood, .flourBasedFood, .bakery, .cafe:
            return UIColor(named: "CateringStore")
        case .hairCut:
            return UIColor(named: "HairCut")
        case .cleaning:
            return UIColor(named: "LaundryShop")
        case .skinCare, .bath:
            return UIColor(named: "ServiceShop")
        case .none:
            return .black
        }
    }
    
    init(shopSubCategory: ShopSubCategory?) {
        self.shopSubCategory = shopSubCategory
    }
}

extension SubCategory: Hashable {
    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }
    
    static func == (lhs: SubCategory, rhs: SubCategory) -> Bool {
      return lhs.identifier == rhs.identifier
    }
}

