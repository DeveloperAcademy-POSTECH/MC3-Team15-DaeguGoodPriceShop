//
//  MapViewController.swift
//  DaeguGoodPriceShop
//
//  Created by Shin Jae Ung on 2022/06/29.
//

import UIKit
import MapKit
import Combine

class MapViewController: UIViewController {
    private let mapViewModel = MapViewModel()
    @IBOutlet weak var mapView: MKMapView!
    private var observers: Set<AnyCancellable> = []
    
    private lazy var userTrackingButton: MKUserTrackingButton = {
        let button = MKUserTrackingButton(mapView: mapView)
        button.isHidden = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureMapView()
        configureBindings()
        addAnnotation()
    }
    
    private func configureView() {
        mapView.addSubview(userTrackingButton)
        
        NSLayoutConstraint.activate([
            userTrackingButton.widthAnchor.constraint(equalToConstant: 50),
            userTrackingButton.heightAnchor.constraint(equalToConstant: 50),
            userTrackingButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -30),
            userTrackingButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -100)
        ])
    }
    
    private func configureMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsLargeContentViewer = true
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
    
    private func addAnnotation(category: ShopCategory? = nil) {
        let shops = mapViewModel.getCategorizedShop(category: category)
        addPins(shops: shops)
    }
    
    private func addPins(shops: [Shop]) {
        for shop in shops {
            guard let category = shop.getCategory() else {
                continue
            }
            
            addPin(category: category, coordinate: shop.location)
        }
    }
    
    private func addPin(category: ShopCategory, coordinate: CLLocation) {
        let pin = ShopAnnotation(category: category, location: coordinate)
        mapView.addAnnotation(pin)
    }
    
    private func removeAnnotation() {
        mapView.removeAnnotations(mapView.annotations)
    }
}
