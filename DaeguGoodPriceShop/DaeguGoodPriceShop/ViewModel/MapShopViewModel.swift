//
//  MapShopViewModel.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/07/27.
//

import Foundation

final class MapShopViewModel {
    private var model: MapModel
    private(set) var isShowingFavorite = false
    private var category: ShopCategory?
    private var subcategory: ShopSubCategory?
    private(set) var isShowingCategory = false
    
    init(mapModel: MapModel) {
        self.model = mapModel
    }
    
    func toggleFavoriteShop(shopId: Int) {
        if model.favoriteShopId.contains(shopId) {
            removeFavoriteShop(shopId: shopId)
        } else {
            addFavoriteShop(shopId: shopId)
        }
    }
    
    private func addFavoriteShop(shopId: Int) {
        model.favoriteShopId.insert(shopId)
        UserDefaults.standard.set(Array(model.favoriteShopId), forKey: "favoriteShopId")
    }
    
    private func removeFavoriteShop(shopId: Int) {
        model.favoriteShopId.remove(shopId)
        UserDefaults.standard.set(Array(model.favoriteShopId), forKey: "favoriteShopId")
    }
    
    func isFavoriteShop(shopId id: Int) -> Bool {
        return model.favoriteShopId.contains(id)
    }
    
    func favoriteShopButtonTouched() {
        isShowingFavorite.toggle()
    }
    
    func categoryButtonTouched() {
        isShowingCategory.toggle()
    }
    
    func setCategory(category: ShopCategory?) {
        self.category = category
    }
    
    func setSubCategory(subcategory: ShopSubCategory?) {
        self.subcategory = subcategory
    }
    
    func getShops() -> [Shop] {
        return model.totalShops
    }
    
    func getFilteredShops(shopCategory: ShopCategory? = nil, shopSubCategory: ShopSubCategory? = nil, favorite: Bool? = nil) -> [Shop] {
        if favorite == nil {
            return model.filteredShops(shopCategory: category, shopSubCategory: subcategory, isShowFavorite: isShowingFavorite)
        } else {
            return model.filteredShops(shopCategory: category, shopSubCategory: subcategory, isShowFavorite: favorite)
        }
    }

    func findShop(shopId id: Int) -> Shop? {
        return model.findById(shopId: id)
    }
}
