//
//  CategoryModalViewController.swift
//  DaeguGoodPriceShop
//
//  Created by Yeongwoo Kim on 2022/07/10.
//

import UIKit

class CategoryModalViewController: ModalViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        super.setupView()
        view.addSubview(dismissButton)
    }
    
    @objc override func panGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown = translation.y > 0
        let newHeight = currentHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < ModalHeight.category.value {
                modalHeight?.constant = newHeight
                parent?.view.layoutIfNeeded()
            }
        case .ended:
            if isDraggingDown {
                changeModalHeight(.zero)
            } else {
                changeModalHeight(.category)
            }
        default:
            break
        }
    }
    
    func initModal() {
        changeModalHeight(.category)
    }
}

