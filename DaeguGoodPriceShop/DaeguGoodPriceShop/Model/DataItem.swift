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

extension DataItem {
    static let categories: [DataItem] = [
        DataItem(categoryName: "한식", categoryColor: UIColor.black),
        DataItem(categoryName: "분식", categoryColor: UIColor.black),
        DataItem(categoryName: "중식", categoryColor: UIColor.black),
        DataItem(categoryName: "양식", categoryColor: UIColor.black),
        DataItem(categoryName: "일식", categoryColor: UIColor.black),
    ]
    
    static let favourites: [DataItem] = [
        DataItem(storeName: "착한가격식당11", storeAddress: "포항시 어디구 여기동 저기로 1", storeCallNumber: "07011111111"),
        DataItem(storeName: "착한가격식당12", storeAddress: "포항시 어디구 여기동 저기로 2", storeCallNumber: "07022222222")
    ]
    
    static let normals: [DataItem] = [
        DataItem(storeName:  "착한가격식당1", storeAddress: "포항시 어디구 여기동 저기로 1", storeCallNumber: "07011111111"),
        DataItem(storeName: "착한가격식당2", storeAddress: "포항시 어디구 여기동 저기로 2", storeCallNumber: "07022222222"),
        DataItem(storeName: "착한가격식당3", storeAddress: "포항시 어디구 여기동 저기로 3", storeCallNumber: "07033333333"),
        DataItem(storeName: "착한가격식당4", storeAddress: "포항시 어디구 여기동 저기로 4", storeCallNumber: "07044444444"),
        DataItem(storeName: "착한가격식당5", storeAddress: "포항시 어디구 여기동 저기로 5", storeCallNumber: "07055555555"),
        DataItem(storeName: "착한가격식당7", storeAddress: "포항시 어디구 여기동 저기로 3", storeCallNumber: "07033333333"),
        DataItem(storeName: "착한가격식당8", storeAddress: "포항시 어디구 여기동 저기로 4", storeCallNumber: "07044444444"),
        DataItem(storeName: "착한가격식당9", storeAddress: "포항시 어디구 여기동 저기로 5", storeCallNumber: "07055555555"),
        DataItem(storeName: "착한가격식당10", storeAddress: "포항시 어디구 여기동 저기로 6", storeCallNumber: "07066666666")
    ]
}
