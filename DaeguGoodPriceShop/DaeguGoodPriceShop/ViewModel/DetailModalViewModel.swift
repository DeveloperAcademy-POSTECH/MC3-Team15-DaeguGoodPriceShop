//
//  DetailModalViewModel.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/07/29.
//

import Foundation

class DetailModalViewModel {
    init() {}
    
    var favoriteShopId: Set<Int> {
        get { Set(UserDefaults.standard.array(forKey: "favoriteShopId") as? [Int] ?? []) }
        set { UserDefaults.standard.set(Array(newValue), forKey: "favoriteShopId") }
    }
    
    func isFavoriteShop(_ shop: Shop) -> Bool {
        return favoriteShopId.contains(shop.serialNumber)
    }
    
    func toggleFavorite(_ shop: Shop) {
        isFavoriteShop(shop) ? favoriteShopId.remove(shop.serialNumber) : favoriteShopId.update(with: shop.serialNumber)
    }
}
