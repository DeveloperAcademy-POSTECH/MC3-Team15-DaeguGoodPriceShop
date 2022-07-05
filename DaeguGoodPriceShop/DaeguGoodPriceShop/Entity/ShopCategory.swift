//
//  ShopCategory.swift
//  DaeguGoodPriceShop
//
//  Created by Yeongwoo Kim on 2022/07/05.
//

import Foundation

enum ShopCategory {
    case restaurant
    case hair
    case laundry
    case beauty
    case bath
    
    func isShopIncludedCategory(subCategory: String) -> Bool {
        switch self {
        case .restaurant:
            let subCategories: Set<String> = ["한식", "중식", "양식", "분식", "제과", "일식", "카페"]
            return subCategories.contains(subCategory)
            
        case .hair:
            return subCategory == "미용"
            
        case .laundry:
            return subCategory == "세탁"
            
        case .beauty:
            return subCategory == "피부미용"
            
        case .bath:
            return subCategory == "목욕"
        }
    }
}
