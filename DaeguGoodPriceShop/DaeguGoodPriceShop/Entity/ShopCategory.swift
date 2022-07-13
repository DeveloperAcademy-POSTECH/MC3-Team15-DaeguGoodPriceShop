//
//  ShopCategory.swift
//  DaeguGoodPriceShop
//
//  Created by Yeongwoo Kim on 2022/07/05.
//

import Foundation
import UIKit

enum ShopSubCategory: String {
    case koreanFood = "한식"
    case chineseFood = "중식"
    case westernFood = "양식"
    case japaneseFood = "일식"
    case flourBasedFood = "분식"
    case bakery = "제과"
    case cafe = "카페"
    case hairCut = "미용"
    case cleaning = "세탁"
    case skinCare = "피부미용"
    case bath = "목욕"
    
    var category: ShopCategory {
        switch self {
        case .koreanFood, .chineseFood, .westernFood, .japaneseFood, .flourBasedFood, .bakery, .cafe:
            return .cateringStore
        case .hairCut:
            return .hairdressingShop
        case .cleaning:
            return .laundryShop
        case .skinCare, .bath:
            return .serviceShop
        }
    }
    
    var categoryColor: UIColor? {
        switch self {
        case .koreanFood, .chineseFood, .westernFood, .japaneseFood, .flourBasedFood, .bakery, .cafe:
            return UIColor(named: "CateringStore")
        case .hairCut:
            return UIColor(named: "HairdressingShop")
        case .cleaning:
            return UIColor(named: "LaundryShop")
        case .skinCare, .bath:
            return UIColor(named: "ServiceShop")
        }
    }
}

enum ShopCategory {
    case cateringStore
    case hairdressingShop
    case laundryShop
    case serviceShop
    
    var subCategories: [ShopSubCategory] {
        switch self {
        case .cateringStore:
            return [.koreanFood, .chineseFood, .westernFood, .japaneseFood, .flourBasedFood, .bakery, .cafe]
        case .hairdressingShop:
            return [.hairCut]
        case .laundryShop:
            return [.cleaning]
        case .serviceShop:
            return [.skinCare, .bath]
        }
    }
}
