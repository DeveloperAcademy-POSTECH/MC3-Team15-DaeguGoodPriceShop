//
//  StoreListViewCell.swift
//  DaeguGoodPriceShop
//
//  Created by 정재윤 on 2022/07/11.
//

import UIKit

class StoreListViewCell: UICollectionViewCell {
    private let locationManager = LocationManager()
    static let identifier = String(describing: StoreListViewCell.self)
    static var height: CGFloat { 160 }

    private var shopCallNumber = ""
    private var shopDistance: Double = 0.0
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var shopMenuPrice: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locationView: UILabel = {
        let loc = UILabel()
        loc.font = .systemFont(ofSize: 15)
        loc.textColor = .gray
        loc.numberOfLines = 0
        loc.translatesAutoresizingMaskIntoConstraints = false
        return loc
    }()
    
    private lazy var callButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        button.addTarget(self, action: #selector(phoneCall), for: .touchUpInside)
        button.tintColor = UIColor(named: "MainColor")
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    func configure(_ item: StoreListItem) {
        configureView()
        titleLabel.text = item.shop.shopName
        shopMenuPrice.text = item.shop.menu + "  " + item.shop.price
        shopCallNumber = item.shop.phoneNumber
        shopDistance = locationManager.calDistance(latitude: item.shop.latitude, longitude: item.shop.longitude)
        locationView.text = String(format: "내 위치에서 %.01fkm 떨어져 있어요", shopDistance)
    }
    
    @objc func phoneCall() {
           guard let url = URL(string: "tel://\(shopCallNumber)"),UIApplication.shared.canOpenURL(url)
           else {
               return
           }
           if #available(iOS 14, *) {
               UIApplication.shared.open(url)
           }
           else {
               UIApplication.shared.openURL(url)
           }
       }
}

extension StoreListViewCell {
    private func configureView() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .systemGray6
        
        [
            titleLabel,
            shopMenuPrice,
            locationView,
            callButton
        ].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18)
        ])
        
        NSLayoutConstraint.activate([
            shopMenuPrice.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            shopMenuPrice.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            shopMenuPrice.widthAnchor.constraint(equalToConstant: contentView.bounds.width * 0.722)
        ])
        
        
        NSLayoutConstraint.activate([
            locationView.topAnchor.constraint(equalTo: shopMenuPrice.bottomAnchor, constant: 30),
            locationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10),
            locationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            locationView.widthAnchor.constraint(equalToConstant: contentView.bounds.width * 0.722)
        ])
        
        NSLayoutConstraint.activate([
            callButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            callButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            callButton.leadingAnchor.constraint(equalTo: shopMenuPrice.trailingAnchor, constant: 20),
            callButton.widthAnchor.constraint(equalToConstant: 50),
            callButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}


