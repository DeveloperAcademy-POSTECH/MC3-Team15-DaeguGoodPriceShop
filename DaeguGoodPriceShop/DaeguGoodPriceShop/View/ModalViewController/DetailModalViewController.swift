//
//  DetailModalViewController.swift
//  DaeguGoodPriceShop
//
//  Created by Yeongwoo Kim on 2022/07/10.
//

import UIKit

final class DetailModalViewController: ModalViewController {
    private let spacer = UIView()
    private let viewModel: DetailModalViewModel
    private let locationManager = LocationManager()
    private var shopSearchName = ""
    private var shopCallAddress = ""
    private var shopCallNumber = ""
    private var shopDistance: Double = 0.0
    private var selectedShop: Shop? {
        didSet {
            setFavoriteButtonImage()
        }
    }
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        button.layer.cornerRadius = 40
        button.clipsToBounds = true
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        return button
    }()
    
    lazy var titleView: UILabel = {
        var title = UILabel()
        title.text = selectedShop?.shopName
        title.font = .boldSystemFont(ofSize: 24)
        return title
    }()
    
    lazy private var locationView: UILabel = {
          var loc = UILabel()
          loc.font = .boldSystemFont(ofSize: 15)
          loc.textColor = .systemGray
          return loc
      }()
    
    lazy var SearchButton: UIButton = {
        let search = UIButton()
        search.setImage(UIImage(systemName: "magnifyingglass.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        search.addTarget(self, action: #selector(searchToNaver), for: .touchUpInside)
        search.tintColor = UIColor(named: "MainColor")
        return search
    }()
    
    lazy var subTitleMenuView: UILabel = {
        let subTitleMenu = UILabel()
        subTitleMenu.text = "메뉴"
        subTitleMenu.font = .boldSystemFont(ofSize: 15)
        return subTitleMenu
    }()
    
    lazy var subTitleInfoView: UILabel = {
        let subTitleInfo = UILabel()
        subTitleInfo.text = "가게 정보"
        subTitleInfo.font = .boldSystemFont(ofSize: 15)
        return subTitleInfo
    }()
    
    lazy var menuNameView: UILabel = {
        var menuName = UILabel()
        menuName.font = UIFont.systemFont(ofSize: 15)
        menuName.text = selectedShop?.menu
        menuName.backgroundColor = .clear
        return menuName
    }()
    
    lazy var menuPriceView: UILabel = {
        var menuPrice = UILabel()
        menuPrice.text = "Price Here"
        menuPrice.font = UIFont.systemFont(ofSize: 15)
        menuPrice.textAlignment = .right
        return menuPrice
    }()
    
    lazy var infoSubTitleAddressView : UILabel = {
        let infoSubTitleAddress = UILabel()
        infoSubTitleAddress.font = UIFont.systemFont(ofSize: 15)
        infoSubTitleAddress.text = "주소"
        infoSubTitleAddress.backgroundColor = .clear
        return infoSubTitleAddress
    }()
    
    lazy var infoSubTitlePhoneView: UILabel = {
        let infoSubTitlePhone = UILabel()
        infoSubTitlePhone.font = UIFont.systemFont(ofSize: 15)
        infoSubTitlePhone.text = "전화번호"
        infoSubTitlePhone.backgroundColor = .clear
        return infoSubTitlePhone
    }()
    
    lazy var infoAddressView: UILabel = {
        var infoAddress = UILabel()
        infoAddress.font = UIFont.systemFont(ofSize: 15)
        infoAddress.text = selectedShop?.address
        infoAddress.backgroundColor = .clear
        return infoAddress
    }()
    
    lazy var infoSymbolCopyButton: UIButton = {
        let infoSymbolCopy = UIButton()
        infoSymbolCopy.setImage(UIImage(systemName: "square.fill.on.square.fill"), for: .normal)
        infoSymbolCopy.addTarget(self, action: #selector(copyAddress), for: .touchUpInside)
        infoSymbolCopy.tintColor = UIColor(named: "MainColor")
        return infoSymbolCopy
    }()
    
    lazy var infoPhoneNumberView: UILabel = {
        var infoPhoneNumber = UILabel()
        infoPhoneNumber.font = UIFont.systemFont(ofSize: 15)
        infoPhoneNumber.text = selectedShop?.phoneNumber
        infoPhoneNumber.backgroundColor = .clear
        return infoPhoneNumber
    }()
    
    lazy var infoSymbolPhoneButton: UIButton = {
        let infoSymbolPhone = UIButton()
        infoSymbolPhone.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        infoSymbolPhone.addTarget(self, action: #selector(phoneCall), for: .touchUpInside)
        infoSymbolPhone.tintColor = UIColor(named: "MainColor")
        return infoSymbolPhone
    }()
    
    lazy var modalPhoneStack: UIStackView = {
        var modalPhone = UIStackView(arrangedSubviews: [infoPhoneNumberView, infoSymbolPhoneButton])
        modalPhone.axis = .horizontal
        modalPhone.spacing = 16.0
        return modalPhone
    }()
    
    lazy var modalAddressStack: UIStackView = {
        var modalAddress = UIStackView(arrangedSubviews: [infoAddressView, infoSymbolCopyButton])
        modalAddress.axis = .horizontal
        modalAddress.spacing = 16.0
        return modalAddress
    }()
    
    lazy var modalInfoStack: UIStackView = {
        let divider = UIView()
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.backgroundColor = .systemGray3
        var modalInfo = UIStackView(arrangedSubviews: [infoSubTitleAddressView, modalAddressStack, divider, infoSubTitlePhoneView, modalPhoneStack])
        modalInfo.axis = .vertical
        modalInfo.spacing = 0.0
        modalInfo.setCustomSpacing(5, after: modalAddressStack)
        modalInfo.setCustomSpacing(20, after: divider)
        modalInfo.customizeBackground(color: .systemGray6, radiusSize: 10.0)
        return modalInfo
    }()
    
    lazy var modalMenuStack: UIStackView = {
        var modalMenu = UIStackView(arrangedSubviews: [menuNameView, menuPriceView])
        modalMenu.axis = .horizontal
        modalMenu.spacing = 16.0
        modalMenu.customizeBackground(color: .systemGray6, radiusSize: 5.0)
        return modalMenu
    }()
    
    lazy var modalTitleStack: UIStackView = {
        var modalTitle = UIStackView(arrangedSubviews: [titleView, SearchButton, spacer, favoriteButton])
        modalTitle.axis = .horizontal
        modalTitle.spacing = 16.0
        return modalTitle
    }()
    
    lazy private var titleVStack: UIStackView = {
        var title = UIStackView(arrangedSubviews: [modalTitleStack, locationView])
        title.axis = .vertical
        title.spacing = 1.0
        return title
    }()
    
    lazy private var modalDetailStack: UIStackView = {
        var modalDetail = UIStackView(arrangedSubviews: [titleVStack, subTitleMenuView, modalMenuStack, subTitleInfoView, modalInfoStack])
        modalDetail.axis = .vertical
        modalDetail.spacing = 10.0
        modalDetail.setCustomSpacing(20.0, after: titleVStack)
        modalDetail.setCustomSpacing(20.0, after: modalMenuStack)
        return modalDetail
    }()
 
    init(viewModel: DetailModalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupPanGesture()
    }
    
    func shopTouched(_ shop: Shop) {
        self.selectedShop = shop
    }
    
    @objc func toggleFavorite() {
        guard let selectedShop = selectedShop else { return }
        viewModel.toggleFavorite(selectedShop)
        setFavoriteButtonImage()
    }
    
    func setFavoriteButtonImage() {
        guard let selectedShop = selectedShop else { return }
        let isFavoriteShop = viewModel.isFavoriteShop(selectedShop)
        favoriteButton.setImage(isFavoriteShop ? UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)) : UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        
        favoriteButton.tintColor = isFavoriteShop ? UIColor(named: "SubColorRed") : UIColor.gray
    }
    
    @objc func searchToNaver() {
        let chopshopCallAddress = shopCallAddress.split(separator: " ")
        let originalURL = "https://m.search.naver.com/search.naver?sm=mtp_hty.top&where=m&query=\(shopSearchName)+\(chopshopCallAddress[0])"
        let encodedLink = originalURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL

        guard let url = URL(string:"\(encodedURL)") else {
            return
        }
        if #available(iOS 14.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    @objc func copyAddress() {
        UIPasteboard.general.string = shopCallAddress
        self.showToast(message: "주소 복사완료!")
       }
    
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: ModalHeight.zero.value-40, width: 150, height: 35))
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
        view.addSubview(modalDetailStack)
        modalDetailStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            modalDetailStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalDetailStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            modalDetailStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            modalDetailStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            modalMenuStack.heightAnchor.constraint(equalToConstant: 40),
            modalMenuStack.leadingAnchor.constraint(equalTo: modalDetailStack.leadingAnchor),
            modalMenuStack.trailingAnchor.constraint(equalTo: modalDetailStack.trailingAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),
            
            menuPriceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.0),
            menuNameView.leadingAnchor.constraint(equalTo: modalMenuStack.leadingAnchor, constant: 15),
            
            infoSymbolCopyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.0),
            infoSymbolCopyButton.widthAnchor.constraint(equalToConstant: 30),
            infoSymbolPhoneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.0),
            infoSymbolPhoneButton.widthAnchor.constraint(equalToConstant: 30),
            
            modalAddressStack.heightAnchor.constraint(equalToConstant: 40),
            modalPhoneStack.heightAnchor.constraint(equalToConstant: 40),
            modalAddressStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            modalPhoneStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            infoSubTitleAddressView.topAnchor.constraint(equalTo: modalInfoStack.topAnchor, constant: 15)
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
        shopDistance = locationManager.calDistance(latitude: selectedShop?.latitude, longitude: selectedShop?.longitude)
        locationView.text = String(format: "내 위치에서 %.01fkm 떨어져 있어요", shopDistance)
        titleView.text = selectedShop?.shopName
        updateDetailModalView()
    }
    
    func updateDetailModalView() {
        menuNameView.text = selectedShop?.menu
        menuPriceView.text = selectedShop?.price
        infoAddressView.text = selectedShop?.address
        infoPhoneNumberView.text = selectedShop?.phoneNumber
        shopSearchName = selectedShop?.shopName ?? ""
        shopCallAddress = selectedShop?.address ?? ""
        shopCallNumber = selectedShop?.phoneNumber ?? ""
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
