//
//  DefaultModalViewController.swift
//  DaeguGoodPriceShop
//
//  Created by Yeongwoo Kim on 2022/07/10.
//

import UIKit

class DefaultModalViewController: ModalViewController {
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    private var collectionView: UICollectionView = UICollectionView()
    
    enum StoreListSection: String, CaseIterable {
        case category = "카테고리"
        case favorite = "즐겨찾기"
        case normal = "목록"
    }
    
    typealias Section = StoreListSection
    private var datasource: UICollectionViewDiffableDataSource<Section, DataItem>!
    
    private var detailCategories: [DataItem] = DataItem.categories
    private var favoriteStores: [DataItem] = DataItem.favorites
    private var normalStores: [DataItem] = DataItem.normals
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        super.setupView()
    }
    
    @objc override func panGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown = translation.y > 0
        let newHeight = currentHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < ModalHeight.maximum.value {
                modalHeight?.constant = newHeight
                parent?.view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < ModalHeight.median.value {
                if isDraggingDown {
                    changeModalHeight(.minimum)
                } else {
                    changeModalHeight(.median)
                }
            } else {
                if isDraggingDown {
                    changeModalHeight(.median)
                } else {
                    changeModalHeight(.maximum)
                }
            }
        default:
            break
        }
    }
}

extension DefaultModalViewController {
    private func configureDataSource() {
        datasource = UICollectionViewDiffableDataSource<Section, DataItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            let sectionType = Section.allCases[indexPath.section]
            
            switch sectionType {
            case .category:
                return UICollectionViewCell()
            case .favorite:
                return UICollectionViewCell()
            case .normal:
                return UICollectionViewCell()
            }
        })
        
        let snapshot = snapshotCurrentState()
        datasource.apply(snapshot)
    }
    
    private func snapshotCurrentState() -> NSDiffableDataSourceSnapshot<Section, DataItem> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DataItem>()
        snapshot.appendSections([.category])
        snapshot.appendItems(detailCategories, toSection: .category)
        
        snapshot.appendSections([.favorite])
        snapshot.appendItems(favoriteStores, toSection: .favorite)
        
        snapshot.appendSections([.normal])
        snapshot.appendItems(normalStores, toSection: .normal)
        
        return snapshot
    }
}
