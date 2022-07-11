//
//  MapViewController.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/06/29.
//

import MapKit
import Combine

class MapViewController: UIViewController {
    private let mapViewModel = MapViewModel()
    @IBOutlet private weak var mapView: MKMapView!
    private var observers: Set<AnyCancellable> = []
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var gestureBarView: UIView!
    let defaultHeight: CGFloat = 250
    let minimumHeight: CGFloat = 70
    let fullHeight: CGFloat = UIScreen.main.bounds.height - 70
    var currentHeight: CGFloat = 70
    var selectedAnnotationView: MKAnnotationView?
   
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
    
    lazy var defaultModalVC: DefaultModalViewController = {
        let defaultModalVC = DefaultModalViewController()
        self.addChild(defaultModalVC)
        view.addSubview(defaultModalVC.view)
        defaultModalVC.willMove(toParent: self)
        defaultModalVC.didMove(toParent: self)
        defaultModalVC.view.translatesAutoresizingMaskIntoConstraints = false
        return defaultModalVC
    }()
    
    lazy var detailModalVC: DetailModalViewController = {
        let detailModalVC = DetailModalViewController()
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
        addAnnotation()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            removeAnnotation()
            mapViewModel.setFavoriteShop()
            addAnnotation()
            // 테스트용, 실제로는 Annotation을 눌렀을 때 Action하는 로직
            detailModalVC.initModal()
            view.setNeedsLayout()
        } else {
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
        
        view.addSubview(defaultModalVC.view)
        view.addSubview(detailModalVC.view)
        view.addSubview(categoryModalVC.view)
        
        NSLayoutConstraint.activate([
            userTrackingButton.widthAnchor.constraint(equalToConstant: 50),
            userTrackingButton.heightAnchor.constraint(equalToConstant: 50),
            userTrackingButton.rightAnchor.constraint(equalTo: self.mapView.rightAnchor, constant: -20),
            userTrackingButton.topAnchor.constraint(equalTo: self.buttonsContainerView.bottomAnchor, constant: 10),
            
            defaultModalVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            defaultModalVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            defaultModalVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            detailModalVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailModalVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailModalVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            categoryModalVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            categoryModalVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryModalVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        defaultModalVC.modalHeight = defaultModalVC.view.heightAnchor.constraint(equalToConstant: ModalHeight.minimum.value)
        detailModalVC.modalHeight = detailModalVC.view.heightAnchor.constraint(equalToConstant: ModalHeight.zero.value)
        categoryModalVC.modalHeight = categoryModalVC.view.heightAnchor.constraint(equalToConstant: ModalHeight.zero.value)
        
        defaultModalVC.modalHeight?.isActive = true
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
    
    private func addAnnotation() {
        mapViewModel.getShops().forEach { shop in
            guard let annotation = ShopAnnotation(of: shop) else { return }
            mapView.addAnnotation(annotation)
        }
    }
    
    private func removeAnnotation() {
        mapView.removeAnnotations(mapView.annotations)
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
    }
}

