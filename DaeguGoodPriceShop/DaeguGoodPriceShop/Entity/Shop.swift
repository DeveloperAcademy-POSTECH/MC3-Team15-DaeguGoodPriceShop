//
//  Shop.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/06/29.
//

import Foundation

struct Shop: Codable {
    let id: Int
    let category: String
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let phoneNumber: String
    let recommended: String
    let price: String
}
