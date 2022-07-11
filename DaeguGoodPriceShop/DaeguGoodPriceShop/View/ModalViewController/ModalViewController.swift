//
//  ModalViewController.swift
//  DaeguGoodPriceShop
//
//  Created by Yeongwoo Kim on 2022/07/10.
//

import UIKit

class ModalViewController: UIViewController {
    lazy var gestureView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var gestureBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.cornerRadius = 2
        return view
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 50, y: 0, width: 50, height: 50))
        view.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    var modalHeight: NSLayoutConstraint?
    var currentHeight: CGFloat = ModalHeight.minimum.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupPanGesture()
    }
    
    @objc func dismissModal() {
        changeModalHeight(ModalHeight.zero.height)
    }
    
    func changeModalHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.modalHeight?.constant = height
            self.parent?.view.layoutIfNeeded()
        }
        
        currentHeight = height
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
        
        
        view.addSubview(gestureView)
        gestureView.addSubview(gestureBarView)
        
        NSLayoutConstraint.activate([
            gestureView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            gestureView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            gestureView.topAnchor.constraint(equalTo: view.topAnchor),
            gestureView.heightAnchor.constraint(equalToConstant: ModalHeight.minimum.height),
            
            gestureBarView.topAnchor.constraint(equalTo: gestureView.topAnchor, constant: 5),
            gestureBarView.widthAnchor.constraint(equalToConstant: 63),
            gestureBarView.heightAnchor.constraint(equalToConstant: 3),
            gestureBarView.centerXAnchor.constraint(equalTo: gestureView.centerXAnchor),
        ])
    }
    
    func setupPanGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture(gesture:)))
        
        gesture.delaysTouchesBegan = false
        gesture.delaysTouchesEnded = false
        
        gestureView.addGestureRecognizer(gesture)
    }
    
    @objc func panGesture(gesture: UIPanGestureRecognizer) {
        
    }
}
