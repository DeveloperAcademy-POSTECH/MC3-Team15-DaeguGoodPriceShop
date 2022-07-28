//
//  MapViewController.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/06/29.
//

import MapKit

class MapViewController: UIViewController {
    let shopViewModel = MapShopViewModel(mapModel: MapModel())
    let locationViewModel = MapLocationViewModel(locationManager: LocationManager())
    @IBOutlet private weak var mapView: MKMapView!
    var selectedAnnotationView: MKAnnotationView?
    var selectedAnnotation: MKAnnotation?
    var selectedShopCategory: ShopCategory?
    var selectedShopSubCategory: ShopSubCategory?
    
    private lazy var userTrackingButton: MKUserTrackingButton = {
        let button = MKUserTrackingButton(mapView: mapView)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var buttonsContainerView: UIView!
    
    lazy var storeListModalVC: StoreListModalViewController = {
        let defaultModalVC = StoreListModalViewController(mapShopViewModel: self.shopViewModel)
        self.addChild(defaultModalVC)
        view.addSubview(defaultModalVC.view)
        defaultModalVC.willMove(toParent: self)
        defaultModalVC.didMove(toParent: self)
        defaultModalVC.view.translatesAutoresizingMaskIntoConstraints = false
        return defaultModalVC
    }()
    
    lazy var detailModalVC: DetailModalViewController = {
        let detailModalVC = DetailModalViewController(mapShopViewModel: self.shopViewModel)
        self.addChild(detailModalVC)
        view.addSubview(detailModalVC.view)
        detailModalVC.willMove(toParent: self)
        detailModalVC.didMove(toParent: self)
        detailModalVC.view.translatesAutoresizingMaskIntoConstraints = false
        return detailModalVC
    }()
    
    lazy var categoryModalVC: CategoryModalViewController = {
        let categoryModalVC = CategoryModalViewController()
        self.addChild(categoryModalVC)
        view.addSubview(categoryModalVC.view)
        categoryModalVC.willMove(toParent: self)
        categoryModalVC.didMove(toParent: self)
        categoryModalVC.view.translatesAutoresizingMaskIntoConstraints = false
        return categoryModalVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureMapView()
        registerAnnotationViewClasses()
        configureBindings()
        addAnnotations()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            likeButtonTapped()
        } else {
            categoryButtonTapped()
        }
    }
    
    private func categoryButtonTapped() {
        shopViewModel.categoryButtonTouched()
        categoryButton.tintColor = shopViewModel.isShowingCategory ? .systemGray6 : .lightGray
        categoryButton.backgroundColor = shopViewModel.isShowingCategory ? UIColor(named: "MainColor") : .systemBackground
        storeListModalVC.selectedSubCategory = nil
        
        if shopViewModel.isShowingCategory {
            updateAnnotation(category: nil)
            categoryModalVC.changeModalHeight(.zero)
            storeListModalVC.changeModalHeight(.zero)
            detailModalVC.changeModalHeight(.zero)
            categoryModalVC.initModal()
        } else {
            updateAnnotation(category: nil)
            updateAnnotation(subCategory: nil)
            storeListModalVC.changeModalHeight(.zero)
            detailModalVC.changeModalHeight(.zero)
            categoryModalVC.changeModalHeight(.zero)
        }
    }
    
    private func likeButtonTapped() {
        updateAnnotation()
        likeButton.tintColor = shopViewModel.isShowingFavorite ? .systemGray6 : .lightGray
        likeButton.backgroundColor = shopViewModel.isShowingFavorite ? UIColor(named: "SubColorRed") : .systemBackground
    }
    
    private func updateAnnotation() {
        let beforeShopsId = shopViewModel.getFilteredShops().map{ $0.serialNumber }
        shopViewModel.favoriteShopButtonTouched()
        let curShopsId = shopViewModel.getFilteredShops().map{ $0.serialNumber }
        
        mapView.annotations.forEach { annotation in
            guard let shopId = (annotation as? ShopAnnotation)?.serialNumber else { return }
            if beforeShopsId.contains(shopId) && !curShopsId.contains(shopId) {
                mapView.removeAnnotation(annotation)
            }
        }
        
        shopViewModel.getShops().forEach { shop in
            if !beforeShopsId.contains(shop.serialNumber) && curShopsId.contains(shop.serialNumber) {
                mapView.addAnnotation(ShopAnnotation(of: shop)!)
            }
        }
    }
    
    private func configureView() {
        buttonsContainerView.layer.cornerRadius = 10
        buttonsContainerView.layer.shadowRadius = 4
        buttonsContainerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        buttonsContainerView.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        
        userTrackingButton.layer.shadowRadius = 4
        userTrackingButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        userTrackingButton.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        
        mapView.addSubview(userTrackingButton)
        
        view.addSubview(categoryModalVC.view)
        view.addSubview(storeListModalVC.view)
        view.addSubview(detailModalVC.view)
        
        categoryModalVC.delegate = self
        storeListModalVC.delegate = self
        
        NSLayoutConstraint.activate([
            userTrackingButton.widthAnchor.constraint(equalToConstant: 50),
            userTrackingButton.heightAnchor.constraint(equalToConstant: 50),
            userTrackingButton.rightAnchor.constraint(equalTo: self.mapView.rightAnchor, constant: -20),
            userTrackingButton.topAnchor.constraint(equalTo: self.buttonsContainerView.bottomAnchor, constant: 10),
            
            storeListModalVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            storeListModalVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            storeListModalVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            detailModalVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailModalVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailModalVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            categoryModalVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            categoryModalVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryModalVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        storeListModalVC.modalHeight = storeListModalVC.view.heightAnchor.constraint(equalToConstant: ModalHeight.zero.value)
        detailModalVC.modalHeight = detailModalVC.view.heightAnchor.constraint(equalToConstant: ModalHeight.zero.value)
        categoryModalVC.modalHeight = categoryModalVC.view.heightAnchor.constraint(equalToConstant: ModalHeight.zero.value)
        
        storeListModalVC.modalHeight?.isActive = true
        detailModalVC.modalHeight?.isActive = true
        categoryModalVC.modalHeight?.isActive = true
    }
    
    private func configureMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = false
        mapView.isRotateEnabled = true
        mapView.showsLargeContentViewer = true
    }
    
    private func registerAnnotationViewClasses() {
        mapView.register(
            KoreanFoodAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: KoreanFoodAnnotationView.identifier
        )
        mapView.register(
            ChineseFoodAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: ChineseFoodAnnotationView.identifier
        )
        mapView.register(
            WesternFoodAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: WesternFoodAnnotationView.identifier
        )
        mapView.register(
            JapaneseFoodAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: JapaneseFoodAnnotationView.identifier
        )
        mapView.register(
            FlourBasedFoodAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: FlourBasedFoodAnnotationView.identifier
        )
        mapView.register(
            BakeryAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: BakeryAnnotationView.identifier
        )
        mapView.register(
            CafeAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: CafeAnnotationView.identifier
        )
        mapView.register(
            HairCutAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: HairCutAnnotationView.identifier
        )
        mapView.register(
            CleaningAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: CleaningAnnotationView.identifier
        )
        mapView.register(
            SkinCareAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: SkinCareAnnotationView.identifier
        )
        mapView.register(
            BathAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: BathAnnotationView.identifier
        )
        mapView.register(
            ClusteringAnnotationView.self,
            forAnnotationViewWithReuseIdentifier:
                MKMapViewDefaultClusterAnnotationViewReuseIdentifier
        )
    }
    
    private func configureBindings() {
        locationViewModel.locationAuthorizationEvent = { [weak self] bool in
            self?.userTrackingButton.isHidden = !bool
        }
        locationViewModel.initialLocationEvent = { [weak self] location in
            self?.configureLocation(location)
        }
    }
    
    private func configureLocation(_ location: CLLocation?) {
        guard let location = location else { return }
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }
    
    private func addAnnotations() {
        shopViewModel.getShops().forEach { shop in
            guard let annotation = ShopAnnotation(of: shop) else { return }
            mapView.addAnnotation(annotation)
        }
    }
    
    private func removeAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    private func zoomTo(shop: Shop) {
        let center = CLLocationCoordinate2D(latitude: shop.latitude - 0.002, longitude: shop.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ShopAnnotation else { return nil }
        switch annotation.shopSubCategory {
        case .koreanFood:
            return mapView.dequeueReusableAnnotationView(withIdentifier: KoreanFoodAnnotationView.identifier)
        case .chineseFood:
            return mapView.dequeueReusableAnnotationView(withIdentifier: ChineseFoodAnnotationView.identifier)
        case .westernFood:
            return mapView.dequeueReusableAnnotationView(withIdentifier: WesternFoodAnnotationView.identifier)
        case .japaneseFood:
            return mapView.dequeueReusableAnnotationView(withIdentifier: JapaneseFoodAnnotationView.identifier)
        case .flourBasedFood:
            return mapView.dequeueReusableAnnotationView(withIdentifier: FlourBasedFoodAnnotationView.identifier)
        case .bakery:
            return mapView.dequeueReusableAnnotationView(withIdentifier: BakeryAnnotationView.identifier)
        case .cafe:
            return mapView.dequeueReusableAnnotationView(withIdentifier: CafeAnnotationView.identifier)
        case .hairCut:
            return mapView.dequeueReusableAnnotationView(withIdentifier: HairCutAnnotationView.identifier)
        case .cleaning:
            return mapView.dequeueReusableAnnotationView(withIdentifier: CleaningAnnotationView.identifier)
        case .skinCare:
            return mapView.dequeueReusableAnnotationView(withIdentifier: SkinCareAnnotationView.identifier)
        case .bath:
            return mapView.dequeueReusableAnnotationView(withIdentifier: BathAnnotationView.identifier)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        selectedAnnotationView?.prepareForDisplay()
        detailModalVC.dismissModal()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedAnnotationView?.prepareForDisplay()
        guard let shopAnnotationView = view as? ShopAnnotationView else { return }
        shopAnnotationView.selected()
        selectedAnnotationView = view
        selectedAnnotation = selectedAnnotationView?.annotation
        
        guard let selectedShopData = view.annotation as? ShopAnnotation else {
            return
        }
        
        detailModalVC.setData(shopId: selectedShopData.serialNumber)
        detailModalVC.initModal()
        zoomTo(shop: shopViewModel.findShop(shopId: selectedShopData.serialNumber)!)
    }
}

extension MapViewController: CategoryFilterable {
    func categoryTouched(_ category: ShopCategory) {
        storeListModalVC.category = category
        updateAnnotation(category: category)
        storeListModalVC.initModal()
    }
    
    
    func removeCategoryFiltering() {
        updateAnnotation(category: nil)
        updateAnnotation(subCategory: nil)
        categoryButtonTapped()
    }
    
    private func updateAnnotation(category: ShopCategory?) {
        let beforeShopsId = shopViewModel.getFilteredShops().map{ $0.serialNumber }
        shopViewModel.setCategory(category: category)
        let curShopsId = shopViewModel.getFilteredShops().map{ $0.serialNumber }
        
        mapView.annotations.forEach { annotation in
            guard let shopId = (annotation as? ShopAnnotation)?.serialNumber else { return }
            if beforeShopsId.contains(shopId) && !curShopsId.contains(shopId) {
                mapView.removeAnnotation(annotation)
            }
        }
        
        shopViewModel.getShops().forEach { shop in
            if !beforeShopsId.contains(shop.serialNumber) && curShopsId.contains(shop.serialNumber) {
                mapView.addAnnotation(ShopAnnotation(of: shop)!)
            }
        }
    }
}

extension MapViewController: SubCategoryFilterable {
    func categoryTouched(_ subCategory: ShopSubCategory?) {
        updateAnnotation(subCategory: subCategory)
    }
    
    private func updateAnnotation(subCategory: ShopSubCategory?) {
        let beforeShopsId = shopViewModel.getFilteredShops().map{ $0.serialNumber }
        shopViewModel.setSubCategory(subcategory: subCategory)
        let curShopsId = shopViewModel.getFilteredShops().map{ $0.serialNumber }
        
        mapView.annotations.forEach { annotation in
            guard let shopId = (annotation as? ShopAnnotation)?.serialNumber else { return }
            if beforeShopsId.contains(shopId) && !curShopsId.contains(shopId) {
                mapView.removeAnnotation(annotation)
            }
        }
        
        shopViewModel.getShops().forEach { shop in
            if !beforeShopsId.contains(shop.serialNumber) && curShopsId.contains(shop.serialNumber) {
                mapView.addAnnotation(ShopAnnotation(of: shop)!)
            }
        }
    }
    
    func shopTouched(ofSerialNumber number: Int) {
        guard let touchedShopIndex = shopViewModel.getShops().firstIndex(where: { $0.serialNumber == number }) else { return }
        let touchedShop = shopViewModel.getShops()[touchedShopIndex]
        zoomTo(shop: touchedShop)
    }
    
    func removeSubCategoryFiltering() {
        updateAnnotation(subCategory: nil)
        updateAnnotation(category: nil)
    }
}
