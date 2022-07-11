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
    
    var modalDetailView: UIStackView = {
        var modalTitleView: UIStackView = {
            let label = UILabel()
            label.text = "착한 짜장"
            label.font = .boldSystemFont(ofSize: 32)
            
            let textView = UITextView(frame: .zero)
            textView.font = UIFont.systemFont(ofSize: 16)
            textView.isEditable = false
            textView.text = "❤️"
            //textView.trailingAnchor.constraint(equalTo: modalTitleView.leadingAnchor).isActive = true
            
            let spacer = UIView()
            
            let titleStack = UIStackView(arrangedSubviews: [label, spacer, textView])
            titleStack.axis = .horizontal
            titleStack.spacing = 16.0
            return titleStack
        }()
        
        var modalMenuView: UIStackView = {
            let menuName = UITextView(frame: .zero)
            menuName.font = UIFont.systemFont(ofSize: 16)
            menuName.isEditable = false
            menuName.text = "짜장면" // TODO: Data
            menuName.isScrollEnabled = false
            
            let menuPrice = UITextView(frame: .zero)
            menuPrice.font = UIFont.systemFont(ofSize: 16)
            menuPrice.isEditable = false
            menuPrice.text = "5000원" // TODO: Data
            menuPrice.isScrollEnabled = false
            
            let spacer = UIView()
            
            let menuStack = UIStackView(arrangedSubviews: [menuName, spacer, menuPrice])
            menuStack.axis = .horizontal
            menuStack.spacing = 16.0
            return menuStack
        }()
        var modalInfoView: UIStackView = {
            var modalAddressView: UIStackView = {
                let infoAddress = UITextView(frame: .zero)
                infoAddress.font = UIFont.systemFont(ofSize: 16)
                infoAddress.isEditable = false
                infoAddress.text = "대구광역시 주소구 주소로 123" // TODO: Data
                infoAddress.isScrollEnabled = false
                
                let infoSymbolCopy = UIImageView()
                infoSymbolCopy.image = UIImage(systemName: "doc.on.doc.fill")
                
                let spacer = UIView()
                
                let infoAddressStack = UIStackView(arrangedSubviews: [infoAddress, spacer, infoSymbolCopy])
                infoAddressStack.axis = .horizontal
                infoAddressStack.spacing = 16.0
                
                NSLayoutConstraint.activate([
                    infoAddress.heightAnchor.constraint(equalToConstant: 30.0)
                ])
                
                return infoAddressStack
            }()
            var modalPhoneView: UIStackView = {
                let infoPhoneNumber = UITextView(frame: .zero)
                infoPhoneNumber.font = UIFont.systemFont(ofSize: 16)
                infoPhoneNumber.isEditable = false
                infoPhoneNumber.text = "010-0000-0000" // TODO: Data
                infoPhoneNumber.textAlignment = .center
                infoPhoneNumber.isScrollEnabled = false
                
                let infoSymbolPhone = UIImageView()
                infoSymbolPhone.image = UIImage(systemName: "phone.fill")
                
                let spacer = UIView()
                
                let infoPhoneStack = UIStackView(arrangedSubviews: [infoPhoneNumber, spacer, infoSymbolPhone])
                infoPhoneStack.axis = .horizontal
                infoPhoneStack.spacing = 16.0
                
                NSLayoutConstraint.activate([
                    infoPhoneNumber.heightAnchor.constraint(equalToConstant: 30.0)
                ])
                
                return infoPhoneStack
            }()
            let infoSubTitleAddress = UITextView(frame: .zero)
            infoSubTitleAddress.font = UIFont.systemFont(ofSize: 16)
            infoSubTitleAddress.isEditable = false
            infoSubTitleAddress.text = "주소"
            infoSubTitleAddress.isScrollEnabled = false
            
            let infoSubTitlePhone = UITextView(frame: .zero)
            infoSubTitlePhone.font = UIFont.systemFont(ofSize: 16)
            infoSubTitlePhone.isEditable = false
            infoSubTitlePhone.text = "전화번호"
            infoSubTitlePhone.isScrollEnabled = false
            
            let infoStack = UIStackView(arrangedSubviews: [infoSubTitleAddress, modalAddressView, infoSubTitlePhone, modalPhoneView])
            infoStack.axis = .vertical
            infoStack.spacing = 16.0
            infoStack.addBackground(color: .systemGray)
            
            return infoStack
        }()
        let subTitleMenu = UILabel()
        subTitleMenu.text = "대표 메뉴"
        subTitleMenu.font = .boldSystemFont(ofSize: 20)
        
        let subTitleInfo = UILabel()
        subTitleInfo.text = "가게 정보"
        subTitleInfo.font = .boldSystemFont(ofSize: 20)
        
        let detailStack = UIStackView(arrangedSubviews: [modalTitleView, subTitleMenu, modalMenuView, subTitleInfo, modalInfoView])
        detailStack.spacing = 16.0
        detailStack.axis = .vertical
        
        /*
        NSLayoutConstraint.activate([
            modalTitleView.heightAnchor.constraint(equalToConstant: 40.0),
            modalMenuView.leadingAnchor.constraint(equalTo: modalTitleView.leadingAnchor),
            modalInfoView.leadingAnchor.constraint(equalTo: modalTitleView.leadingAnchor),
            subTitleMenu.leadingAnchor.constraint(equalTo: modalTitleView.leadingAnchor),
            subTitleInfo.leadingAnchor.constraint(equalTo: modalTitleView.leadingAnchor)
        ])
         */
        
        return detailStack
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
            
            modalDetailView.widthAnchor.constraint(equalToConstant: self.view.frame.width),
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
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}

