//
//  StoreListViewCell.swift
//  DaeguGoodPriceShop
//
//  Created by 정재윤 on 2022/07/11.
//

import UIKit

class StoreListViewCell: UICollectionViewCell {
    static let identifier = "store-list-view-cell"
    static var height: CGFloat { 160 }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var callButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "phone"), for: .normal)
        button.tintColor = UIColor(displayP3Red: 50/255, green: 105/255, blue: 217/255, alpha: 1.0)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    func configure(_ item: DataItem) {
        configureView()
        
        titleLabel.text = item.storeName
        addressLabel.text = item.storeAddress
    }
}

extension StoreListViewCell {
    private func configureView() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        
        [
            titleLabel,
            addressLabel,
            callButton
        ].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18)
        ])
        
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            addressLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width * 0.722)
        ])
        
        NSLayoutConstraint.activate([
            callButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            callButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            callButton.leadingAnchor.constraint(equalTo: addressLabel.trailingAnchor, constant: 20),
            callButton.widthAnchor.constraint(equalToConstant: 50),
            callButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}


