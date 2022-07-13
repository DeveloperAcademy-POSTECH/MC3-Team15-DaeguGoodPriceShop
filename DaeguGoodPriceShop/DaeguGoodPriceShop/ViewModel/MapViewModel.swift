//
//  MapViewModel.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/06/29.
//

import Foundation
import CoreLocation
import Combine

final class MapViewModel {
    @Published private(set) var locationAutorization: Bool = false
    @Published private(set) var initialLocation: CLLocation?
    private let locationManager = LocationManager()
    private var model = MapModel()
    private var isFavorite = false
    private var category: ShopCategory?
    private var subcategory: ShopSubCategory?
    private var distance: CLLocationDistance?
    
    init() {
        configureBindings()
        configureLocationManager()
    }
    
    func configureBindings() {
        locationManager.locationAuthorizationEvent = { [weak self] bool in
            self?.locationAutorization = bool
        }
        locationManager.initialLocationEvent = { [weak self] location in
            self?.initialLocation = location
        }
    }
    
    func configureLocationManager() {
        locationManager.configureAutorization()
    }
    
    private func getDistanceFromUser(_ shop: Shop) -> CLLocationDistance {
        return initialLocation?.distance(from: CLLocation(latitude: shop.latitude, longitude: shop.longitude)) ?? CLLocationDistance.infinity
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
    
    func setFavoriteShop() {
        isFavorite.toggle()
    }
    
    func setCategory(category: ShopCategory?) {
        self.category = category
    }
    
    func setSubCategory(subcategory: ShopSubCategory?) {
        self.subcategory = subcategory
    }
    
    func getShops() -> [Shop] {
        return model.shops
    }
    
    func getFilteredShops(shopCategory: ShopCategory? = nil, shopSubCategory: ShopSubCategory? = nil, favorite: Bool? = nil) -> [Shop] {
        return model.filteredShops(shopCategory: shopCategory, shopSubCategory: shopSubCategory, favorite: favorite)
    }
    
    func findShop(shopId id: Int) -> Shop? {
        return model.findById(shopId: id)
    }
}
