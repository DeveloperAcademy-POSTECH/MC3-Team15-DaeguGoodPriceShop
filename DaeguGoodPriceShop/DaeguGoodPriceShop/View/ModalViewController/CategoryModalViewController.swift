//
//  CategoryModalViewController.swift
//  DaeguGoodPriceShop
//
//  Created by Yeongwoo Kim on 2022/07/10.
//

import UIKit

protocol CategoryFilterable: AnyObject {
    func categoryTouched(_ category: ShopCategory)
    func removeCategoryFiltering()
}

class CategoryTapGestureRecognizer: UITapGestureRecognizer {
    var category: ShopCategory?
}

class CategoryModalViewController: ModalViewController {
    weak var delegate: CategoryFilterable?
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.text = "업종 선택"
        label.font = .boldSystemFont(ofSize: 24)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var innerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    lazy var cateringStoreButtonView: UIStackView = {
        let imageView = UIImageView()
        let label = UILabel()
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.alignment = .center
        imageView.image = resizedImage(image: UIImage(named: "cateringCategory"), width: 160, height: 100)
        imageView.contentMode = .scaleAspectFill
        label.text = "요식업"
        label.textColor = .white
        label.font = UIFont.preferredFont(for: .body, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        stackView.backgroundColor = UIColor(named: "CateringStore")
        stackView.clipsToBounds = true
        let tabGesture = CategoryTapGestureRecognizer(target: self, action: #selector(buttonViewTouched(gesture:)))
        tabGesture.category = .cateringStore
        stackView.addGestureRecognizer(tabGesture)
        return stackView
    }()
    
    lazy var hairdressingShop: UIStackView = {
        let imageView = UIImageView()
        let label = UILabel()
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.alignment = .center
        imageView.image = resizedImage(image: UIImage(named: "hairCategory"), width: 160, height: 100)
        imageView.contentMode = .scaleAspectFill
        label.text = "미용업"
        label.textColor = .white
        label.font = UIFont.preferredFont(for: .body, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        stackView.backgroundColor = UIColor(named: "HairdressingShop")
        stackView.clipsToBounds = true
        let tabGesture = CategoryTapGestureRecognizer(target: self, action: #selector(buttonViewTouched(gesture:)))
        tabGesture.category = .hairdressingShop
        stackView.addGestureRecognizer(tabGesture)
        return stackView
    }()
    
    lazy var laundryShop: UIStackView = {
        let imageView = UIImageView()
        let label = UILabel()
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.alignment = .center
        imageView.image = resizedImage(image: UIImage(named: "laundryCategory"), width: 160, height: 100)
        imageView.contentMode = .scaleAspectFill
        label.text = "세탁업"
        label.textColor = .white
        label.font = UIFont.preferredFont(for: .body, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        stackView.backgroundColor = UIColor(named: "LaundryShop")
        stackView.clipsToBounds = true
        let tabGesture = CategoryTapGestureRecognizer(target: self, action: #selector(buttonViewTouched(gesture:)))
        tabGesture.category = .laundryShop
        stackView.addGestureRecognizer(tabGesture)
        return stackView
    }()
    
    lazy var serviceShop: UIStackView = {
        let imageView = UIImageView()
        let label = UILabel()
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.alignment = .center
        imageView.image = resizedImage(image: UIImage(named: "serviceCategory"), width: 160, height: 100)
        imageView.contentMode = .scaleAspectFill
        label.text = "서비스업"
        label.textColor = .white
        label.font = UIFont.preferredFont(for: .body, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        stackView.backgroundColor = UIColor(named: "ServiceShop")
        stackView.clipsToBounds = true
        let tabGesture = CategoryTapGestureRecognizer(target: self, action: #selector(buttonViewTouched(gesture:)))
        tabGesture.category = .serviceShop
        stackView.addGestureRecognizer(tabGesture)
        return stackView
    }()
    
    lazy var upperStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cateringStoreButtonView, hairdressingShop])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        return stackView
    }()
    
    lazy var underStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [laundryShop, serviceShop])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        return stackView
    }()
    
    lazy var totalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [upperStackView, underStackView])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        super.setupView()
        view.addSubview(innerScrollView)
        innerScrollView.addSubview(textLabel)
        innerScrollView.addSubview(totalStackView)
        
        
        cateringStoreButtonView.layer.cornerRadius = 5
        hairdressingShop.layer.cornerRadius = 5
        laundryShop.layer.cornerRadius = 5
        serviceShop.layer.cornerRadius = 5
        
        NSLayoutConstraint.activate([
            innerScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            innerScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            innerScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            innerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leftAnchor.constraint(equalTo: innerScrollView.leftAnchor, constant: 15),
            textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            totalStackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30),
            totalStackView.leftAnchor.constraint(equalTo: innerScrollView.leftAnchor, constant: 15),
            totalStackView.topAnchor.constraint(equalTo: self.textLabel.bottomAnchor, constant: 30),
            totalStackView.bottomAnchor.constraint(equalTo: innerScrollView.bottomAnchor, constant: -50),
            totalStackView.rightAnchor.constraint(equalTo: innerScrollView.rightAnchor, constant: -15)
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
            }
        case .ended:
            if isDraggingDown {
                changeModalHeight(.zero)
                self.delegate?.removeCategoryFiltering()
            } else {
                changeModalHeight(.median)
            }
        default:
            break
        }
    }
    
    @objc func buttonViewTouched(gesture: CategoryTapGestureRecognizer?) {
        guard let category = gesture?.category else { return }
        self.delegate?.categoryTouched(category)
    }
    
    func initModal() {
        changeModalHeight(.median)
    }
    
    func resizedImage(image: UIImage?, width: CGFloat, height: CGFloat) -> UIImage? {
         guard let image = image else { return nil }
         let newSize = CGSize(width: width, height: height)
         UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
         image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
         let newImage = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         return newImage
     }
}

