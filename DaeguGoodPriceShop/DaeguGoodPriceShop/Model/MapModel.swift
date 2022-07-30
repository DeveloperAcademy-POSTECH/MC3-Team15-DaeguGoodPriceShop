//
//  MapModel.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/06/29.
//

import Foundation
import OSLog

final class MapModel {
    private enum DataFetchingError: Error {
        case invalidURL
        case urlUnableToConvertToData
        case unDecodable
    }
    
    var totalShops: [Shop] = []
    var favoriteShopId: Set<Int> {
        get { Set(UserDefaults.standard.array(forKey: "favoriteShopId") as? [Int] ?? []) }
        set { UserDefaults.standard.set(Array(newValue), forKey: "favoriteShopId") }
    }
    
    init() {
        Task {
            self.totalShops = await asyncFetchShops()
        }
    }
    
    func filteredShops(shopCategory: ShopCategory? = nil, shopSubCategory: ShopSubCategory? = nil, isShowFavorite: Bool? = nil) -> [Shop] {
        var result = totalShops
        
        if let shopCategory = shopCategory {
            result = result.filter{
                guard let shopSubCategory = $0.shopSubCategory else { return false }
                return shopCategory.subCategories.contains(shopSubCategory)
            }
        }
        
        if let shopSubCategory = shopSubCategory {
            result = result.filter{ $0.shopSubCategory == shopSubCategory }
        }
        
        if let isFavorite = isShowFavorite {
            if isFavorite {
                result = result.filter{ favoriteShopId.contains($0.serialNumber) }
            }
        }
        
        return result
    }
    
    private func asyncFetchShops() async -> [Shop] {
        typealias ShopContinuation = CheckedContinuation<[Shop], Never>
        return await withCheckedContinuation { (continuation: CheckedContinuation) in
            fetchShopsFromJson { shops in
                continuation.resume(returning: shops)
            }
        }
    }
    
    private func fetchShopsFromJson(completion: @escaping ([Shop]) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let fileName = "DaeguGoodPriceShop"
            guard let fileLocation = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                os_log(.error, log: .default, "INVALID URL: \(DataFetchingError.invalidURL.localizedDescription)")
                completion([])
                return
            }
            guard let data = try? Data(contentsOf: fileLocation) else {
                os_log(.error, log: .default, "URL UNABLE: \(DataFetchingError.urlUnableToConvertToData.localizedDescription)")
                completion([])
                return
            }
            guard let shops = try? JSONDecoder().decode([Shop].self, from: data) else {
                os_log(.error, log: .default, "UNDECODABLE: \(DataFetchingError.unDecodable.localizedDescription)")
                completion([])
                return
            }
            completion(shops)
        }
    }
    
    func findById(shopId id: Int) -> Shop? {
        return totalShops.first(where: {$0.serialNumber == id })
    }
}
