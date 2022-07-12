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
    
        configureDataSource()
        
        configureCollectionViewLayout()
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
        
        datasource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView else {
                fatalError("cannot create header view")
            }
            
            supplementaryView.label.text = Section.allCases[indexPath.section].rawValue
            
            return supplementaryView
        }
        
        let snapshot = snapshotCurrentState()
        datasource.apply(snapshot)
    }
    
    private func configureCollectionViewLayout() {
        collectionView.isPrefetchingEnabled = false
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: DefaultModalViewController.sectionHeaderElementKind, withReuseIdentifier: HeaderView.reuseIdentifier)
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
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
