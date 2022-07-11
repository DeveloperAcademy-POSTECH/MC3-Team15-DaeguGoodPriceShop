//
//  DataItem.swift
//  DaeguGoodPriceShop
//
//  Created by 정재윤 on 2022/07/11.
//

import UIKit


class DataItem: Hashable {
    let categoryName: String?
    let categoryColor: UIColor?
    
    let storeName: String?
    let storeAddress: String?
    let storeCallNumber: String?
    
    init(categoryName: String?, categoryColor: UIColor?, storeName: String?, storeAddress: String?, storeCallNumber: String?) {
        self.categoryName = categoryName
        self.categoryColor = categoryColor
        self.storeName = storeName
        self.storeAddress = storeAddress
        self.storeCallNumber = storeCallNumber
    }
    
    convenience init(categoryName: String, categoryColor: UIColor?) {
        self.init(categoryName: categoryName, categoryColor: categoryColor, storeName: nil, storeAddress: nil, storeCallNumber: nil)
    }
    
    convenience init(storeName: String?, storeAddress: String?, storeCallNumber: String?) {
        self.init(categoryName: nil, categoryColor: nil, storeName: storeName, storeAddress: storeAddress, storeCallNumber: storeCallNumber)
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }
    
    static func == (lhs: DataItem, rhs: DataItem) -> Bool {
      return lhs.identifier == rhs.identifier
    }

    private let identifier = UUID()
}

