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
    
    lazy var storeListModalVC: StoreListModalViewController = {
        let defaultModalVC = StoreListModalViewController(viewModel: self.shopViewModel)
        self.addChild(defaultModalVC)
        view.addSubview(defaultModalVC.view)
        defaultModalVC.willMove(toParent: self)
        defaultModalVC.didMove(toParent: self)
        defaultModalVC.view.translatesAutoresizingMaskIntoConstraints = false
        return defaultModalVC
    }()
    
    lazy var detailModalVC: DetailModalViewController = {
        let detailModalVC = DetailModalViewController(viewModel: DetailModalViewModel())
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
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var categoryButton: UIButton!
    @IBOutlet private weak var buttonsContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureMapView()
        registerAnnotationViewClasses()
        configureBindings()
        shopViewModel.viewDidLoad()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            likeButtonTapped()
        } else {
            shopViewModel.categoryButtonTouched()
        }
    }
    
    private func likeButtonTapped() {
        shopViewModel.favoriteShopButtonTouched()
        likeButton.tintColor = shopViewModel.isShowingFavorite ? .systemBackground : UIColor(named: "SubColorRed")
        likeButton.backgroundColor = shopViewModel.isShowingFavorite ? UIColor(named: "SubColorRed") : .systemBackground
    }
    
    private func updateAnnotation() {
        shopViewModel.shopsShouldBeAdded.forEach { shop in
            guard let shopAnnotation = ShopAnnotation(of: shop) else { return }
            mapView.addAnnotation(shopAnnotation)
        }
        
        mapView.annotations.forEach { annotation in
            guard let shopAnnotation = annotation as? ShopAnnotation,
                  shopViewModel.shopsShouldBeRemoved.contains(shopAnnotation.shop)
            else {
                return
            }
            mapView.removeAnnotation(annotation)
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
        categoryModalVC.dismissDelegate = self
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
        shopViewModel.shopVisibilityChangedEventForMapView = { [weak self] in
            self?.updateAnnotation()
        }
        shopViewModel.categoryShowingChangedEvent = { [weak self] bool in
            self?.updateViewFromCategoryButton(isSelected: bool)
        }
    }
    
    private func updateViewFromCategoryButton(isSelected: Bool) {
        switch isSelected {
        case true:
            categoryButton.tintColor = .systemBackground
            categoryButton.backgroundColor = UIColor(named: "MainColor")
            categoryModalVC.changeModalHeight(.zero)
            storeListModalVC.changeModalHeight(.zero)
            detailModalVC.changeModalHeight(.zero)
            categoryModalVC.initModal()
        case false:
            categoryButton.tintColor = UIColor(named: "MainColor")
            categoryButton.backgroundColor = .systemBackground
            storeListModalVC.changeModalHeight(.zero)
            detailModalVC.changeModalHeight(.zero)
            categoryModalVC.changeModalHeight(.zero)
            shopViewModel.storeListModalViewDismissed()
        }
    }
    
    private func configureLocation(_ location: CLLocation?) {
        guard let location = location else { return }
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }
    
    private func zoomTo(_ view: MKAnnotationView) {
        let currentSpan = mapView.region.span
        let newLongitudeDelta = currentSpan.longitudeDelta / 3
        let newLatitudeDelta = currentSpan.latitudeDelta / 3
        guard let centerCoordinate = view.annotation?.coordinate else { return }
        let newCenter = CLLocationCoordinate2D(latitude: centerCoordinate.latitude - newLatitudeDelta / 3, longitude: centerCoordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: newLongitudeDelta, longitudeDelta: newLatitudeDelta)
        let region = MKCoordinateRegion(center: newCenter, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func zoomTo(_ shop: Shop) {
        let center = CLLocationCoordinate2D(latitude: shop.latitude - 0.002, longitude: shop.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func zoomToCluster(clusteringAnnotation: MKClusterAnnotation) {
        let calData = calculateClusterZoomregion(memberAnnotations: clusteringAnnotation.memberAnnotations)
        let span = MKCoordinateSpan(latitudeDelta: calData.1, longitudeDelta: calData.1)
        let region = MKCoordinateRegion(center: calData.0, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func calculateClusterZoomregion(memberAnnotations: [MKAnnotation]) -> (CLLocationCoordinate2D, Double) {
        let maxLatitude = memberAnnotations.map { $0.coordinate.latitude }.max()
        let minLatitude = memberAnnotations.map { $0.coordinate.latitude }.min()
        let maxLongitude = memberAnnotations.map { $0.coordinate.longitude }.max()
        let minLongitude = memberAnnotations.map { $0.coordinate.longitude }.min()
        if let bigLatitude = maxLatitude, let smallLatitude = minLatitude, let bigLongitude = maxLongitude, let smallLongitude = minLongitude {
            let center = CLLocationCoordinate2D(latitude: Double(bigLatitude + smallLatitude) / 2.0, longitude: Double(bigLongitude + smallLongitude) / 2.0)
            let latitudeGap = Double(bigLatitude) - Double(smallLatitude)
            let longitudeGap = Double(bigLongitude) - Double(smallLongitude)
            if latitudeGap >= longitudeGap{
                return (center, latitudeGap + 0.003)
            } else {
                return (center, longitudeGap + 0.003)
            }
        } else {
            return (CLLocationCoordinate2D(latitude: 35.8714, longitude: 128.6014), 0.1)
        }
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
        if let shopAnnotationView = view as? ShopAnnotationView {
            shopAnnotationView.selected()
            selectedAnnotationView = view
            selectedAnnotation = selectedAnnotationView?.annotation
            guard view.annotation is ShopAnnotation else { return }
            guard let selectedShopAnnotation = view.annotation as? ShopAnnotation else { return }
            detailModalVC.shopTouched(selectedShopAnnotation.shop)
            detailModalVC.initModal()
            zoomTo(view)
        } else if let clusteringAnnotationView = view as? ClusteringAnnotationView {
            selectedAnnotationView = clusteringAnnotationView
            selectedAnnotation = selectedAnnotationView?.annotation
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard view is ClusteringAnnotationView else { return }
        selectedAnnotationView = view
        selectedAnnotation = selectedAnnotationView?.annotation
        
        guard let selectedAnnotation = view.annotation as? MKClusterAnnotation else { return }
        zoomToCluster(clusteringAnnotation: selectedAnnotation)
    }
}

extension MapViewController: CategoryFilterable {
    func categoryTouched(_ category: ShopCategory) {
        shopViewModel.shopCategoryTouched(category)
        storeListModalVC.initModal()
    }
    
    func removeCategoryFiltering() {
        shopViewModel.storeListModalViewDismissed()
    }
}

extension MapViewController: ShopAnnotationZoomable {
    func shopTouched(_ shop: Shop) {
        zoomTo(shop)
    }
}

extension MapViewController: ModalDismissable {
    func dismissed() {
        self.shopViewModel.categoryButtonTouched()
    }
}
