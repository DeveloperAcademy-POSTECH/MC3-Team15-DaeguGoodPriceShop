//
//  MapShopViewModel.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/07/27.
//

import Foundation

final class MapShopViewModel {
    private var model: MapModel
    private(set) var category: ShopCategory?
    private(set) var subCategory: ShopSubCategory?
    private(set) var isShowingFavorite = false
    private(set) var shopsShouldBeAdded: [Shop] = []
    private(set) var shopsShouldRemain: [Shop] = []
    private(set) var shopsShouldBeRemoved: [Shop] = []
    private(set) var isShowingCategory = false {
        willSet {
            categoryShowingChangedEvent(newValue)
        }
    }
    var favoriteShopsOfCurrentShops: [Shop] {
        model.filteredShops(shopCategory: self.category, shopSubCategory: self.subCategory, isShowFavorite: true)
    }
    var shopVisibilityChangedEventForMapView: () -> () = { }
    var categoryShowingChangedEvent: (Bool) -> () = { _ in }
    
    init(mapModel: MapModel) {
        self.model = mapModel
        configureBinding()
    }
    
    func viewDidLoad() {
        model.fetchTotalShop()
    }
    
    private func configureBinding() {
        model.totalShopFetchedEvent = { [weak self] in
            self?.updateShops()
        }
    }

    func toggleFavorite(of shop: Shop) {
        model.toggleFavorite(of: shop)
    }
    
    func favoriteShopButtonTouched() {
        isShowingFavorite.toggle()
        updateShops()
    }
    
    func categoryButtonTouched() {
        isShowingCategory.toggle()
    }
    
    func storeListModalViewDismissed() {
        category = nil
        subCategory = nil
        updateShops()
    }
    
    func shopCategoryTouched(_ category: ShopCategory) {
        self.category = category
        updateShops()
    }
    
    func shopSubCategoryTouched(_ subCategory: ShopSubCategory) {
        self.subCategory = subCategory
        updateShops()
    }
    
    func shopSubCategoryTouched(of indexPath: IndexPath) {
        guard let category = category else { return }
        shopSubCategoryTouched(category.subCategories[indexPath.item])
    }
    
    private func updateShops() {
        let filteredShops = model.filteredShops(shopCategory: category, shopSubCategory: subCategory, isShowFavorite: isShowingFavorite)
        
        let currentShops = shopsShouldBeAdded + shopsShouldRemain
        shopsShouldBeAdded = filteredShops.filter{ !currentShops.contains($0) }
        shopsShouldBeRemoved = currentShops.filter{ !filteredShops.contains($0) }
        shopsShouldRemain = currentShops.filter { filteredShops.contains($0) }
        shopVisibilityChangedEventForMapView()
    }
}
