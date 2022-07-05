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
        addAnnotation(shops: mapViewModel.model.shops)
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
    
    private func addAnnotation(shops: [Shop]) {
        for shop in shops {
            guard let category = shop.getCategory() else {
                continue
            }
            
            addPin(category: category, coordinate: shop.location)
        }
    }
    
    private func removeAnnotation() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    private func addPin(category: ShopCategory, coordinate: CLLocation) {
        let pin = ShopAnnotation(category: category, location: coordinate)
        mapView.addAnnotation(pin)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ShopAnnotation else {
            return nil
        }
        
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: ShopAnnotationView.identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: ShopAnnotationView.identifier)
            annotationView?.canShowCallout = false
            annotationView?.contentMode = .scaleAspectFit
        } else {
            annotationView?.annotation = annotation
        }
        
        let annotationImage: UIImage!
        let size = CGSize(width: 30, height: 30)
        UIGraphicsBeginImageContext(size)
        
        //TODO: Annotation Image 추가
        switch annotation.category {
        case .restaurant:
            annotationImage = UIImage(systemName: "book")?.withTintColor(.red)
        case .hair:
            annotationImage = UIImage(systemName: "doc")?.withTintColor(.blue)
        case .laundry:
            annotationImage = UIImage(systemName: "paperplane")?.withTintColor(.orange)
        case .beauty:
            annotationImage = UIImage(systemName: "trash")?.withTintColor(.yellow)
        case .bath:
            annotationImage = UIImage(systemName: "swift")?.withTintColor(.purple)
        }
        
        annotationImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView?.image = resizedImage
        
        return annotationView
    }
}
