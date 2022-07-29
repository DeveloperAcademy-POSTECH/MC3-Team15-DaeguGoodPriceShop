//
//  StoreListItem.swift
//  DaeguGoodPriceShop
//
//  Created by 정재윤 on 2022/07/13.
//

import UIKit

class StoreListItem {
    private let identifier = UUID()
    let shop: Shop
    
    init(shop: Shop) {
        self.shop = shop
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



