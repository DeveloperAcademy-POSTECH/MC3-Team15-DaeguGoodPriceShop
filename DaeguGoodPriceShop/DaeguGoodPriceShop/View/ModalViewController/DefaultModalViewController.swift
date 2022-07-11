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
        case favourite = "즐겨찾기"
        case normal = "목록"
    }
    
    typealias Section = StoreListSection
    private var datasource: UICollectionViewDiffableDataSource<Section, DataItem>!
    
    private var detailCategories: [DataItem] = DataItem.categories
    private var favouriteStores: [DataItem] = DataItem.favourites
    private var normalStores: [DataItem] = DataItem.normals
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureDataSource()
        
        collectionView.collectionViewLayout = generateLayout()
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
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCategoryViewCell.identifier, for: indexPath) as? DetailCategoryViewCell else { return nil }
                
                cell.configure(item)
                
                return cell
                
            case .favourite:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreListViewCell.identifier, for: indexPath) as? StoreListViewCell else { return nil }
                
                cell.configure(item)
                
                return cell
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
        
        collectionView.register(DetailCategoryViewCell.self, forCellWithReuseIdentifier: DetailCategoryViewCell.identifier)
        collectionView.register(StoreListViewCell.self, forCellWithReuseIdentifier: StoreListViewCell.identifier)
        
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: DefaultModalViewController.sectionHeaderElementKind, withReuseIdentifier: HeaderView.reuseIdentifier)
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }
    
    private func generateLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout{ (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let sectionLayoutKind = Section.allCases[sectionIndex]
            
            switch sectionLayoutKind {
            case .category: return self.generateCategoryLayout()
            case .favourite: return self.generateFavouriteLayout()
            case .normal: return self.generateCategoryLayout()
            }
        }
        
        return layout
    }
    
    private func generateCategoryLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(70),
            heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: DefaultModalViewController.sectionHeaderElementKind,
            alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private func generateFavouriteLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(160))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(160))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: DefaultModalViewController.sectionHeaderElementKind, alignment: .top)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        section.interGroupSpacing = 10
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func snapshotCurrentState() -> NSDiffableDataSourceSnapshot<Section, DataItem> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DataItem>()
        snapshot.appendSections([.category])
        snapshot.appendItems(detailCategories, toSection: .category)
        
        snapshot.appendSections([.favourite])
        snapshot.appendItems(favouriteStores, toSection: .favourite)
        
        snapshot.appendSections([.normal])
        snapshot.appendItems(normalStores, toSection: .normal)
        
        return snapshot
    }
}
