//
//  StoreListItem.swift
//  DaeguGoodPriceShop
//
//  Created by 정재윤 on 2022/07/13.
//

import UIKit

class StoreListItem {
    private let identifier = UUID()
    
    let storeName: String?
    let storeAddress: String?
    let storeCallNumber: String?
    let storeSerialNumber: Int?
    
    init(storeName: String?, storeAddress: String?, storeCallNumber: String?, storeSerialNumber: Int?) {
        self.storeName = storeName
        self.storeAddress = storeAddress
        self.storeCallNumber = storeCallNumber
        self.storeSerialNumber = storeSerialNumber
    }
}

extension StoreListItem: Hashable {
    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }
    
    static func == (lhs: StoreListItem, rhs: StoreListItem) -> Bool {
      return lhs.identifier == rhs.identifier
    }
}

extension StoreListItem {
    static let favourites: [StoreListItem] = [
        StoreListItem(storeName: "착한가격식당11", storeAddress: "포항시 어디구 여기동 저기로 1", storeCallNumber: "07011111111", storeSerialNumber: 1),
        StoreListItem(storeName: "착한가격식당12", storeAddress: "포항시 어디구 여기동 저기로 2", storeCallNumber: "07022222222", storeSerialNumber: 1)
    ]
}



