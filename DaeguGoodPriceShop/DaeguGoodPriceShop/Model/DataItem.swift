//
//  DataItem.swift
//  DaeguGoodPriceShop
//
//  Created by 정재윤 on 2022/07/11.
//

import UIKit

class DataItem: Hashable {
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
    let storeName: String?
    let storeAddress: String?
    let storeCallNumber: String?
    let storeSerialNumber: Int?
    
    init(shopSubCategory: ShopSubCategory?, storeName: String?, storeAddress: String?, storeCallNumber: String?, storeSerialNumber: Int?) {
        self.shopSubCategory = shopSubCategory
        self.storeName = storeName
        self.storeAddress = storeAddress
        self.storeCallNumber = storeCallNumber
        self.storeSerialNumber = storeSerialNumber
    }
    
    convenience init(shopSubCategory: ShopSubCategory?) {
        self.init(shopSubCategory: shopSubCategory, storeName: nil, storeAddress: nil, storeCallNumber: nil, storeSerialNumber: nil)
    }
    
    convenience init(storeName: String?, storeAddress: String?, storeCallNumber: String?, storeSerialNumber: Int?) {
        self.init(shopSubCategory: nil, storeName: storeName, storeAddress: storeAddress, storeCallNumber: storeCallNumber, storeSerialNumber: storeSerialNumber)
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }
    
    static func == (lhs: DataItem, rhs: DataItem) -> Bool {
      return lhs.identifier == rhs.identifier
    }

    private let identifier = UUID()
}

extension DataItem {
    static let favourites: [DataItem] = [
        DataItem(storeName: "착한가격식당11", storeAddress: "포항시 어디구 여기동 저기로 1", storeCallNumber: "07011111111", storeSerialNumber: 1),
        DataItem(storeName: "착한가격식당12", storeAddress: "포항시 어디구 여기동 저기로 2", storeCallNumber: "07022222222", storeSerialNumber: 1)
    ]
}
