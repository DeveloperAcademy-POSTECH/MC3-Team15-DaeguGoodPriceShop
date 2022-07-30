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
    var totalShops: [Shop] = [] {
        didSet {
            totalShopFetchedEvent()
        }
    }
    var favoriteShopId: Set<Int> {
        get { Set(UserDefaults.standard.array(forKey: "favoriteShopId") as? [Int] ?? []) }
        set { UserDefaults.standard.set(Array(newValue), forKey: "favoriteShopId") }
    }
    var totalShopFetchedEvent: () -> () = { }
    
    func fetchTotalShop() {
        Task {
            do {
                self.totalShops = try await fetchShopsFromJson()
            } catch {
                os_log(.error, log: .default, "\(error.localizedDescription)")
            }
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
    
    private func fetchShopsFromJson() async throws -> [Shop] {
        let fileName = "DaeguGoodPriceShop"
        guard let fileLocation = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw DataFetchingError.invalidURL
        }
        guard let data = try? Data(contentsOf: fileLocation) else {
            throw DataFetchingError.urlUnableToConvertToData
        }
        guard let shops = try? JSONDecoder().decode([Shop].self, from: data) else {
            throw DataFetchingError.unDecodable
        }
        return shops
    }

    func toggleFavorite(of shop: Shop) {
        isFavorite(shop: shop) ? removeFavorite(shop: shop) : addFavorite(shop: shop)
    }
    
    private func addFavorite(shop: Shop) {
        let serialNumber = shop.serialNumber
        favoriteShopId.insert(serialNumber)
    }
    
    private func removeFavorite(shop: Shop) {
        let serialNumber = shop.serialNumber
        favoriteShopId.remove(serialNumber)
    }
    
    private func isFavorite(shop: Shop) -> Bool {
        let serialNumber = shop.serialNumber
        return favoriteShopId.contains(serialNumber)
    }
}
