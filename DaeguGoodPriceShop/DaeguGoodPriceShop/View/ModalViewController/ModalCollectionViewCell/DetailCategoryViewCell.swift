//
//  DetailCategoryViewCell.swift
//  DaeguGoodPriceShop
//
//  Created by 정재윤 on 2022/07/11.
//

import UIKit

class DetailCategoryViewCell: UICollectionViewCell {
    static let identifier = String(describing: DetailCategoryViewCell.self)
    
    private lazy var categoryItemButton: UIButton = {
        let button = UIButton()
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.titleLabel?.textColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
        
    func configure(_ item: SubCategory) {
        configureView()
        
        categoryItemButton.backgroundColor = item.categoryColor ?? .black
        categoryItemButton.setTitle(item.shopSubCategory?.rawValue ?? "", for: .normal)
    }
}

extension DetailCategoryViewCell {
    private func configureView() {
        addSubview(categoryItemButton)
        
        NSLayoutConstraint.activate([
            categoryItemButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            categoryItemButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            categoryItemButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            categoryItemButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            categoryItemButton.heightAnchor.constraint(equalToConstant: 40),
            categoryItemButton.widthAnchor.constraint(equalToConstant: 70),
        ])
    }
}
