//
//  MapViewController.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/06/29.
//

import MapKit
import Combine

class MapViewController: UIViewController {
    let mapViewModel = MapViewModel()
    @IBOutlet private weak var mapView: MKMapView!
    private var observers: Set<AnyCancellable> = []
    var selectedAnnotationView: MKAnnotationView?
    var selectedAnnotation: MKAnnotation?
    
    private lazy var userTrackingButton: MKUserTrackingButton = {
        let button = MKUserTrackingButton(mapView: mapView)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var buttonsContainerView: UIView!
    
    lazy var storeListModalVC: StoreListModalViewController = {
        let defaultModalVC = StoreListModalViewController(mapViewModel: self.mapViewModel)
        self.addChild(defaultModalVC)
        view.addSubview(defaultModalVC.view)
        defaultModalVC.willMove(toParent: self)
        defaultModalVC.didMove(toParent: self)
        defaultModalVC.view.translatesAutoresizingMaskIntoConstraints = false
        return defaultModalVC
    }()
    
    lazy var detailModalVC: DetailModalViewController = {
        let detailModalVC = DetailModalViewController(mapViewModel: self.mapViewModel)
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
            mapViewModel.favoriteShopButtonTouched()
            removeAnnotations()
            mapViewModel.getFilteredShops(favorite: mapViewModel.isShowingFavorite ? true : nil).forEach { shop in
                guard let annotation = ShopAnnotation(of: shop) else { return }
                mapView.addAnnotation(annotation)
            }
            categoryModalVC.changeModalHeight(ModalHeight.zero)
            storeListModalVC.changeModalHeight(.zero)
        } else {
            storeListModalVC.changeModalHeight(.zero)
            detailModalVC.changeModalHeight(ModalHeight.zero)
            categoryModalVC.initModal()
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
        mapView.showsCompass = true
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
        mapViewModel.$locationAutorization
            .sink { [weak self] bool in
                self?.userTrackingButton.isHidden = !bool
            }
            .store(in: &self.observers)
        mapViewModel.$initialLocation
            .sink { [weak self] location in
                self?.configureLocation(location)
            }
            .store(in: &self.observers)
    }
    
    private func configureLocation(_ location: CLLocation?) {
        guard let location = location else { return }
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }
    
    private func addAnnotations() {
        mapViewModel.getShops().forEach { shop in
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
        categoryModalVC.changeModalHeight(.zero)
        storeListModalVC.changeModalHeight(.zero)
//        zoomTo(shop: mapViewModel.findShop(shopId: selectedShopData.serialNumber)!)
    }
    
    //    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    //        guard let selectedShopData = view.annotation as? ShopAnnotation else {
    //            return
    //        }
    //
    //        detailModalVC.setData(shopId: selectedShopData.serialNumber)
    //        detailModalVC.initModal()
    //    }
}

extension MapViewController: CategoryFilterable {
    func categoryTouched(_ category: ShopCategory) {
        removeAnnotations()
        mapViewModel.getShops().forEach { shop in
            guard let shopSubCategory = shop.shopSubCategory, category.subCategories.contains(shopSubCategory) else { return }
            guard let annotation = ShopAnnotation(of: shop) else { return }
            mapView.addAnnotation(annotation)
        }
        storeListModalVC.category = category
        storeListModalVC.initModal()
    }
}

extension MapViewController: SubCategoryFilterable {
    func categoryTouched(_ category: ShopSubCategory) {
        removeAnnotations()
        mapViewModel.getShops().forEach { shop in
            guard let shopSubCategory = shop.shopSubCategory, category == shopSubCategory else { return }
            guard let annotation = ShopAnnotation(of: shop) else { return }
            mapView.addAnnotation(annotation)
        }
    }
    
    func shopTouched(ofSerialNumber number: Int) {
        guard let touchedShopIndex = mapViewModel.getShops().firstIndex(where: { $0.serialNumber == number }) else { return }
        let touchedShop = mapViewModel.getShops()[touchedShopIndex]
        zoomTo(shop: touchedShop)
    }
}
