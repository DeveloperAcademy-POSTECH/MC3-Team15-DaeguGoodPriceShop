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
    
    let spacer = UIView()
    
    lazy var favoriteButton: UIButton = {
        var isFavoriteShop = mapViewModel?.isFavoriteShop(shopId: selectedShop?.serialNumber ?? 0)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = selectedShop?.shopName
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    lazy var subTitleMenu: UILabel = {
        let label = UILabel()
        label.text = "메뉴"
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    lazy var subTitleInfo: UILabel = {
        let label = UILabel()
        label.text = "가게 정보"
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    lazy var menuName: UITextView = {
        let menuName = UITextView(frame: .zero)
        menuName.font = UIFont.systemFont(ofSize: 15)
        menuName.isEditable = false
        menuName.text = selectedShop?.menu // TODO: Data
        menuName.isScrollEnabled = false
        menuName.backgroundColor = .clear
        return menuName
    }()
    
    lazy var menuPrice: UITextView = {
        let menuPrice = UITextView(frame: .zero)
        menuPrice.font = UIFont.systemFont(ofSize: 15)
        menuPrice.isEditable = false
        menuPrice.text = selectedShop?.price // TODO: Data
        menuPrice.isScrollEnabled = false
        menuPrice.backgroundColor = .clear
        return menuPrice
    }()
    
    lazy var infoSubTitleAddress : UITextView = {
        let infoSubTitleAddress = UITextView(frame: .zero)
        infoSubTitleAddress.font = UIFont.systemFont(ofSize: 15)
        infoSubTitleAddress.isEditable = false
        infoSubTitleAddress.text = "주소"
        infoSubTitleAddress.isScrollEnabled = false
        infoSubTitleAddress.backgroundColor = .clear
        return infoSubTitleAddress
    }()
    
    lazy var infoSubTitlePhone: UITextView = {
        let infoSubTitlePhone = UITextView(frame: .zero)
        infoSubTitlePhone.font = UIFont.systemFont(ofSize: 15)
        infoSubTitlePhone.isEditable = false
        infoSubTitlePhone.text = "전화 번호"
        infoSubTitlePhone.isScrollEnabled = false
        infoSubTitlePhone.backgroundColor = .clear
        return infoSubTitlePhone
    }()
    
    lazy var infoAddress: UITextView = {
        let infoAddress = UITextView(frame: .zero)
        infoAddress.font = UIFont.systemFont(ofSize: 15)
        infoAddress.isEditable = false
        infoAddress.text = selectedShop?.address // TODO: Data
        infoAddress.isScrollEnabled = false
        infoAddress.backgroundColor = .clear
        return infoAddress
    }()
    
    lazy var infoPhoneNumber: UITextView = {
        let infoPhoneNumber = UITextView(frame: .zero)
        infoPhoneNumber.font = UIFont.systemFont(ofSize: 15)
        infoPhoneNumber.isEditable = false
        infoPhoneNumber.text = selectedShop?.phoneNumber // TODO: Data
        infoPhoneNumber.isScrollEnabled = false
        infoPhoneNumber.backgroundColor = .clear
        return infoPhoneNumber
    }()
    
    lazy var modalPhoneView: UIStackView = {
        let modalPhoneView = UIStackView()
        modalPhoneView.addSubview(infoPhoneNumber)
        modalPhoneView.addSubview(spacer)
        modalPhoneView.axis = .horizontal
        modalPhoneView.spacing = 16.0
        return modalPhoneView
    }()
    
    lazy var modalAddressView: UIStackView = {
        let modalAddressView = UIStackView()
        modalAddressView.addSubview(infoAddress)
        modalAddressView.addSubview(spacer)
        modalAddressView.axis = .horizontal
        modalAddressView.spacing = 16.0
        return modalAddressView
    }()
    
    lazy var modalInfoView: UIStackView = {
        let modalInfoView = UIStackView()
        modalInfoView.addSubview(infoSubTitleAddress)
        modalInfoView.addSubview(modalAddressView)
        modalInfoView.addSubview(infoSubTitlePhone)
        modalInfoView.addSubview(modalPhoneView)
        modalInfoView.axis = .vertical
        modalInfoView.spacing = 16.0
        return modalInfoView
    }()
    
    lazy var modalMenuView: UIStackView = {
        let modalMenuView = UIStackView()
        modalMenuView.addSubview(menuName)
        modalMenuView.addSubview(spacer)
        modalMenuView.addSubview(menuPrice)
        modalMenuView.axis = .horizontal
        modalMenuView.spacing = 16.0
        return modalMenuView
    }()
    
    lazy var modalTitleView: UIStackView = {
        let modalTitleView = UIStackView()
        modalTitleView.addSubview(titleLabel)
        modalTitleView.addSubview(spacer)
        modalTitleView.axis = .horizontal
        modalTitleView.spacing = 16.0
        return modalTitleView
    }()
    
    lazy var modalDetailView: UIStackView = {
        let modalDetailView = UIStackView()
        modalDetailView.addSubview(modalTitleView)
        modalDetailView.addSubview(subTitleMenu)
        modalDetailView.addSubview(modalMenuView)
        modalDetailView.addSubview(subTitleInfo)
        modalDetailView.addSubview(modalInfoView)
        modalDetailView.axis = .vertical
        modalDetailView.spacing = 16.0
        return modalDetailView
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
        view.addSubview(modalDetailView)
        setFavoriteButtonImage()
        modalDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dismissButton.widthAnchor.constraint(equalToConstant: 30),
            dismissButton.heightAnchor.constraint(equalToConstant: 30),
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            favoriteButton.topAnchor.constraint(equalTo: dismissButton.topAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: dismissButton.leadingAnchor),
        
            modalDetailView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 30.0),
            modalDetailView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalDetailView.topAnchor.constraint(equalTo: gestureView.bottomAnchor, constant: -30)
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

extension UIStackView {
    func customizeBackground(color: UIColor, radiusSize: CGFloat = 0.0) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
        
        subView.layer.cornerRadius = radiusSize
        subView.layer.masksToBounds = true
        subView.clipsToBounds = true
    }
}
