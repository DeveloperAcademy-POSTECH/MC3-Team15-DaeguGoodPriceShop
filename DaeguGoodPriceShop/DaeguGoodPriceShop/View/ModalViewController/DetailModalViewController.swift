//
//  DetailModalViewController.swift
//  DaeguGoodPriceShop
//
//  Created by Yeongwoo Kim on 2022/07/10.
//

import UIKit

class DetailModalViewController: ModalViewController {
    let mapViewModel: MapViewModel
    
    private var selectedShop: Shop? {
        didSet {
            setFavoriteButtonImage()
        }
    }
    
    private var shopCallAddress = ""
    private var shopCallNumber = ""
 
    init(mapViewModel: MapViewModel) {
        self.mapViewModel = mapViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let spacer = UIView()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
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
        var menuName = UITextView(frame: .zero)
        menuName.font = UIFont.systemFont(ofSize: 15)
        menuName.isEditable = false
        menuName.text = selectedShop?.menu
        menuName.isScrollEnabled = false
        menuName.backgroundColor = .clear
        return menuName
    }()
    
    lazy var menuPrice: UILabel = {
        var price = UILabel()
        price.text = "1500"
        price.font = UIFont.systemFont(ofSize: 15)
        return price
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
        infoSubTitlePhone.text = "전화번호"
        infoSubTitlePhone.isScrollEnabled = false
        infoSubTitlePhone.backgroundColor = .clear
        return infoSubTitlePhone
    }()
    
    lazy var infoAddress: UITextView = {
        var infoAddress = UITextView(frame: .zero)
        infoAddress.font = UIFont.systemFont(ofSize: 15)
        infoAddress.isEditable = false
        infoAddress.text = selectedShop?.address
        infoAddress.isScrollEnabled = false
        infoAddress.backgroundColor = .clear
        return infoAddress
    }()
    
    lazy var infoSymbolCopy: UIButton = {
        let infoSymbolCopy = UIButton()
        infoSymbolCopy.setImage(UIImage(systemName: "doc.on.doc.fill"), for: .normal)
        infoSymbolCopy.addTarget(self, action: #selector(copyAddress), for: .touchUpInside)
        return infoSymbolCopy
    }()
    
    lazy var infoPhoneNumber: UITextView = {
        var infoPhoneNumber = UITextView(frame: .zero)
        infoPhoneNumber.font = UIFont.systemFont(ofSize: 15)
        infoPhoneNumber.isEditable = false
        infoPhoneNumber.text = selectedShop?.phoneNumber
        infoPhoneNumber.isScrollEnabled = false
        infoPhoneNumber.backgroundColor = .clear
        return infoPhoneNumber
    }()
    
    lazy var infoSymbolPhone: UIButton = {
        let infoSymbolPhone = UIButton()
        infoSymbolPhone.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        infoSymbolPhone.addTarget(self, action: #selector(phoneCall), for: .touchUpInside)
        return infoSymbolPhone
    }()
    
    lazy var modalPhoneView: UIStackView = {
        var modalPhoneView = UIStackView(arrangedSubviews: [infoPhoneNumber, infoSymbolPhone])
        modalPhoneView.axis = .horizontal
        modalPhoneView.spacing = 16.0
        return modalPhoneView
    }()
    
    lazy var modalAddressView: UIStackView = {
        var modalAddressView = UIStackView(arrangedSubviews: [infoAddress, infoSymbolCopy])
        modalAddressView.axis = .horizontal
        modalAddressView.spacing = 16.0
        return modalAddressView
    }()
    
    lazy var modalInfoView: UIStackView = {
        let divider = UIView()
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.backgroundColor = .systemGray3
        var modalInfoView = UIStackView(arrangedSubviews: [infoSubTitleAddress, modalAddressView, divider, infoSubTitlePhone, modalPhoneView])
        modalInfoView.axis = .vertical
        modalInfoView.spacing = 0.0
        modalInfoView.setCustomSpacing(8, after: modalAddressView)
        modalInfoView.setCustomSpacing(8, after: divider)
        modalInfoView.customizeBackground(color: .systemGray6, radiusSize: 10.0)
        return modalInfoView
    }()
    
    lazy var modalMenuView: UIStackView = {
        var modalMenuView = UIStackView(arrangedSubviews: [menuName, menuPrice])
        modalMenuView.axis = .horizontal
        modalMenuView.spacing = 16.0
        modalMenuView.customizeBackground(color: .systemGray6, radiusSize: 5.0)
        return modalMenuView
    }()
    
    lazy var modalTitleView: UIStackView = {
        var modalTitleView = UIStackView(arrangedSubviews: [titleLabel, spacer, favoriteButton])
        modalTitleView.axis = .horizontal
        modalTitleView.spacing = 16.0
        return modalTitleView
    }()
    
    lazy var modalDetailView: UIStackView = {
        var modalDetailView = UIStackView(arrangedSubviews: [modalTitleView, subTitleMenu, modalMenuView, subTitleInfo, modalInfoView])
        modalDetailView.axis = .vertical
        modalDetailView.spacing = 10.0
        modalDetailView.setCustomSpacing(20.0, after: modalTitleView)
        modalDetailView.setCustomSpacing(20.0, after: modalMenuView)
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
        
        mapViewModel.toggleFavoriteShop(shopId: shop.serialNumber)
        setFavoriteButtonImage()
    }
    
    func setFavoriteButtonImage() {
        let isFavoriteShop = mapViewModel.isFavoriteShop(shopId: selectedShop?.serialNumber ?? 0)
        favoriteButton.setImage(isFavoriteShop ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        
        favoriteButton.tintColor = isFavoriteShop ? UIColor.red : UIColor.gray
    }
    
    @objc func copyAddress() {
        UIPasteboard.general.string = shopCallAddress
        self.showToast(message: "주소 복사완료!")
       }
    
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
            let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-350, width: 150, height: 35))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.font = font
            toastLabel.textAlignment = .center;
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseOut, animations: {
                 toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    
    @objc func phoneCall() {
           guard let url = URL(string: "tel://\(shopCallNumber)"),UIApplication.shared.canOpenURL(url)
           else {
               return
           }
           if #available(iOS 14, *) {
               UIApplication.shared.open(url)
           }
           else {
               UIApplication.shared.openURL(url)
           }
       }
    
    override func setupView() {
        super.setupView()
        view.addSubview(modalDetailView)
        setFavoriteButtonImage()
        modalDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            menuPrice.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.0),
            infoSymbolCopy.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.0),
            infoSymbolPhone.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.0),
            
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
            modalHeight?.constant = newHeight
            parent?.view.layoutIfNeeded()
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
        titleLabel.text = selectedShop?.shopName
        menuName.text = selectedShop?.menu
        menuPrice.text = selectedShop?.price
        infoAddress.text = selectedShop?.address
        infoPhoneNumber.text = selectedShop?.phoneNumber
        shopCallAddress = selectedShop?.address ?? ""
        shopCallNumber = selectedShop?.phoneNumber ?? ""
    }
    
    func setData(shopId id: Int) {
        selectedShop = mapViewModel.findShop(shopId: id)
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
