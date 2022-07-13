//
//  StoreListModalViewController.swift
//  DaeguGoodPriceShop
//
//  Created by Yeongwoo Kim on 2022/07/10.
//

import UIKit

protocol SubCategoryFilterable: AnyObject {
    func categoryTouched(_ category: ShopSubCategory)
    func shopTouched(ofSerialNumber number: Int)
}

class StoreListModalViewController: ModalViewController {
    var mapViewModel: MapViewModel
    var delegate: SubCategoryFilterable?
    var category: ShopCategory?
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return cv
    }()
    
    enum StoreListSection: String, CaseIterable {
        case category = "카테고리"
        case favourite = "즐겨찾기"
        case normal = "목록"
    }
    
    typealias Section = StoreListSection
    private var datasource: UICollectionViewDiffableDataSource<Section, DataItem>!
    
    private var detailCategories: [DataItem] {
        guard let category = self.category else { return [] }
        var dataItems: [DataItem] = []
        category.subCategories.forEach {
            let dataItem = DataItem(shopSubCategory: $0)
            dataItems.append(dataItem)
        }
        return dataItems
    }
    private var favouriteStores: [DataItem] = []
    private var normalStores: [DataItem] = []
    
    private func configureNormalStores(ofCategory category: ShopCategory?) {
        guard let category = self.category else { return }
        var dataItems: [DataItem] = []
        mapViewModel.getFilteredShops(shopCategory: category).forEach { shop in
            let dataItem = DataItem(storeName: shop.shopName, storeAddress: shop.address, storeCallNumber: shop.phoneNumber, storeSerialNumber: shop.serialNumber)
            dataItems.append(dataItem)
        }
        self.normalStores = dataItems
    }
    
    private func configureNormalStores(ofSubCategory category: ShopSubCategory) {
        var dataItems: [DataItem] = []
        mapViewModel.getFilteredShops(shopSubCategory: category).forEach { shop in
            let dataItem = DataItem(storeName: shop.shopName, storeAddress: shop.address, storeCallNumber: shop.phoneNumber, storeSerialNumber: shop.serialNumber)
            dataItems.append(dataItem)
        }
        self.normalStores = dataItems
    }
    
    private func configureFavoriteStores(ofCategory category: ShopCategory?) {
        var dataItems: [DataItem] = []
        mapViewModel.getFilteredShops(shopCategory: category, favorite: true).forEach { shop in
            let dataItem = DataItem(storeName: shop.shopName, storeAddress: shop.address, storeCallNumber: shop.phoneNumber, storeSerialNumber: shop.serialNumber)
            dataItems.append(dataItem)
        }
        self.favouriteStores = dataItems
    }
    
    private func configureFavoriteStores(ofSubCategory category: ShopSubCategory?) {
        var dataItems: [DataItem] = []
        mapViewModel.getFilteredShops(shopSubCategory: category, favorite: true).forEach { shop in
            let dataItem = DataItem(storeName: shop.shopName, storeAddress: shop.address, storeCallNumber: shop.phoneNumber, storeSerialNumber: shop.serialNumber)
            dataItems.append(dataItem)
        }
        self.favouriteStores = dataItems
    }
    
    init(category: ShopCategory? = nil, mapViewModel: MapViewModel) {
        self.category = category
        self.mapViewModel = mapViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
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
                    changeModalHeight(.zero)
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
    
    func initModal() {
        changeModalHeight(.median)
        configureNormalStores(ofCategory: category)
        configureFavoriteStores(ofCategory: category)
        configureDataSource()
    }
}

extension StoreListModalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let category = category else { return }
        switch indexPath.section {
        case 0:
            delegate?.categoryTouched(category.subCategories[indexPath.item])
            configureNormalStores(ofSubCategory: category.subCategories[indexPath.item])
            configureFavoriteStores(ofSubCategory: category.subCategories[indexPath.item])
            configureDataSource()
        case 1: Void()
        case 2:
            guard let serialNumber = normalStores[indexPath.item].storeSerialNumber else { return }
            delegate?.shopTouched(ofSerialNumber: serialNumber)
        default: break
        }
    }
}

extension StoreListModalViewController {
    
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
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreListViewCell.identifier, for: indexPath) as? StoreListViewCell else { return nil }
                cell.configure(item)
                
                return cell
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
        
        collectionView.register(
            DetailCategoryViewCell.self,
            forCellWithReuseIdentifier: DetailCategoryViewCell.identifier
        )
        
        collectionView.register(
            StoreListViewCell.self,
            forCellWithReuseIdentifier: StoreListViewCell.identifier
        )
        
        collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: StoreListModalViewController.sectionHeaderElementKind,
            withReuseIdentifier: HeaderView.reuseIdentifier
        )
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
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
            case .normal: return self.generateNormalLayout()
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
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: StoreListModalViewController.sectionHeaderElementKind,
            alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private func generateFavouriteLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(StoreListViewCell.height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(StoreListViewCell.height))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: StoreListModalViewController.sectionHeaderElementKind, alignment: .top)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        section.interGroupSpacing = 10
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func generateNormalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(160))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(160))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: StoreListModalViewController.sectionHeaderElementKind, alignment: .top)
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
