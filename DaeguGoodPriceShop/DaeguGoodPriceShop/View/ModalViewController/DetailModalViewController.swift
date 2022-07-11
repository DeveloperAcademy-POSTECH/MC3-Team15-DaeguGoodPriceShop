//
//  DetailModalViewController.swift
//  DaeguGoodPriceShop
//
//  Created by Yeongwoo Kim on 2022/07/10.
//

import UIKit

class DetailModalViewController: ModalViewController {
    lazy var defaultViewController = parent?.children.first(where: { $0 is DefaultModalViewController }) as! DefaultModalViewController
    lazy var mapViewModel = (parent as? MapViewController)?.mapViewModel
    private var selectedShop: Shop? {
        didSet {
            setFavoriteButtonImage()
        }
    }
    
    lazy var favoriteButton: UIButton = {
        var isFavoriteShop = mapViewModel?.isFavoriteShop(shopId: selectedShop?.serialNumber ?? 0)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupPanGesture()
    }
    
    @objc func toggleFavorite() {
        guard let shop = selectedShop else {
            return
        }

        mapViewModel?.toggleFavoriteShop(shopId: shop.serialNumber)
        setFavoriteButtonImage()
        (parent as? MapViewController)?.updateAnnotation()
    }
    
    func setFavoriteButtonImage() {
        let isFavoriteShop = mapViewModel?.isFavoriteShop(shopId: selectedShop?.serialNumber ?? 0)
        favoriteButton.setImage(isFavoriteShop ?? false ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = (isFavoriteShop ?? false) ? UIColor.red : UIColor.gray
    }
    
    override func setupView() {
        super.setupView()
        view.addSubview(dismissButton)
        view.addSubview(favoriteButton)
        setFavoriteButtonImage()
        
        NSLayoutConstraint.activate([
            dismissButton.widthAnchor.constraint(equalToConstant: 30),
            dismissButton.heightAnchor.constraint(equalToConstant: 30),
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            favoriteButton.topAnchor.constraint(equalTo: dismissButton.topAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: dismissButton.leadingAnchor)
        ])
    }
    
    @objc override func panGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown = translation.y > 0
        let newHeight = currentHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < ModalHeight.median.value {
                modalHeight?.constant = newHeight
                parent?.view.layoutIfNeeded()
                defaultViewController.modalHeight?.constant = newHeight
                parent?.view.layoutIfNeeded()
            } else if newHeight < ModalHeight.maximum.value {
                modalHeight?.constant = newHeight
                parent?.view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < ModalHeight.median.value {
                if isDraggingDown {
                    changeModalHeight(.minimum)
                    defaultViewController.changeModalHeight(.minimum)
                } else {
                    changeModalHeight(.median)
                    defaultViewController.changeModalHeight(.median)
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
        defaultViewController.changeModalHeight(.median)
    }
    
    func setData(shopId id: Int) {
        selectedShop = mapViewModel?.findShop(shopId: id)
    }
    
    @objc override func dismissModal() {
        super.dismissModal()
        selectedShop = nil
    }
}

