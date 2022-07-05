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
    
    static func getCategory(subCategory: String) -> ShopCategory? {
        switch subCategory {
        case "한식", "중식", "양식", "분식", "제과", "일식", "카페":
            return .restaurant
            
        case "미용":
            return .hair
            
        case "세탁":
            return .laundry
            
        case "피부미용":
            return .beauty
            
        case "목욕":
            return .bath
            
        default:
            return nil
        }
    }
}
