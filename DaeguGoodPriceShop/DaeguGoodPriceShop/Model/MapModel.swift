//
//  MapModel.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/06/29.
//

import Foundation
import OSLog

struct MapModel {
    private enum DataFetchingError: Error {
        case invalidURL
        case urlUnableToConvertToData
        case unDecodable
    }
    
    var shops: [Shop] = []
    
    init() {
        shops = getShopData()
    }
    
    private func getShopData() -> [Shop] {
        let fileName = "DaeguGoodPriceShop"
        guard let fileLocation = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            os_log(.error, log: .default, "\(DataFetchingError.invalidURL.localizedDescription)")
            return []
        }
        
        guard let data = try? Data(contentsOf: fileLocation) else {
            os_log(.error, log: .default, "\(DataFetchingError.urlUnableToConvertToData.localizedDescription)")
            return []
        }
        
        guard let shops = try? JSONDecoder().decode([Shop].self, from: data) else {
            os_log(.error, log: .default, "\(DataFetchingError.unDecodable.localizedDescription)")
            return []
        }
        
        os_log(.debug, log: .default, "Successfully Get Json Data")
        return shops
    }
}

