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
//
//    private func getDistanceString(_ distance: Double) -> String {
//        return distance < 1000 ? String(format: "%.1f", distance) + "m" : String(format: "%.1f", distance / 1000) + "km"
//    }
//
//    func getNearShopsFromUser() -> [Shop] {
//        return model.shops
//                .filter{ getDistanceFromUser($0) < 1000 }
//                .sorted{ getDistanceFromUser($0) < getDistanceFromUser($1) }
//    }
    
//    func getShops() -> [Shop] {
//        return self.model.shops.filter { shop in
//            guard shop.shopSubCategory != nil else { return false }
//            return true
//        }
//    }
    
    func toggleFavoriteShop(shopId: Int) {
        if model.favoriteShopId.contains(shopId) {
            removeFavoriteShop(shopId: shopId)
        } else {
            addFavoriteShop(shopId: shopId)
        }
    }
    
    private func addFavoriteShop(shopId: Int) {
        model.favoriteShopId.insert(shopId)
        //TODO: Add 할 때마다 UserDefault에 올라가게 되어있지만 그럴 필요가 없다.
        UserDefaults.standard.set(model.favoriteShopId, forKey: "favoriteShopId")
    }
    
    private func removeFavoriteShop(shopId: Int) {
        model.favoriteShopId.remove(shopId)
        //TODO: Remove 할 때마다 UserDefault에 올라가게 되어있지만 그럴 필요가 없다.
        UserDefaults.standard.set(model.favoriteShopId, forKey: "favoriteShopId")
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
        var filteredShop = model.shops

        filteredShop = filterByDistance(shops: filteredShop)
        filteredShop = filterByFavorite(shops: filteredShop)
        filteredShop = filterByCategory(shops: filteredShop)

        return filteredShop
    }
    
    private func filterByDistance(shops: [Shop]) -> [Shop] {
        if let distance = distance {
            return shops.filter{ getDistanceFromUser($0) < distance }
        }
        
        return shops
    }
    
    private func filterByFavorite(shops: [Shop]) -> [Shop] {
        if isFavorite {
            return shops.filter{ model.favoriteShopId.contains($0.serialNumber) }
        }
        
        return shops
    }
    
    private func filterByCategory(shops: [Shop]) -> [Shop] {
        guard let category = category else {
            return shops
        }
        
        let filterdShop = shops.filter{ $0.shopSubCategory?.category == category }
        
        guard let subcategory = subcategory else {
            return filterdShop
        }
        
        return filterdShop.filter{ $0.shopSubCategory == subcategory }
    }
}
