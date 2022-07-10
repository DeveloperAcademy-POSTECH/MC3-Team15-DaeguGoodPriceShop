//
//  DefaultModalViewController.swift
//  DaeguGoodPriceShop
//
//  Created by Yeongwoo Kim on 2022/07/10.
//

import UIKit

class DefaultModalViewController: ModalViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        super.setupView()
    }
    
    @objc override func panGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown = translation.y > 0
        let newHeight = currentHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < ModalHeight.maximum.height {
                modalHeight?.constant = newHeight
                parent?.view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < ModalHeight.median.height {
                if isDraggingDown {
                    changeModalHeight(ModalHeight.minimum.height)
                } else {
                    changeModalHeight(ModalHeight.median.height)
                }
            } else {
                if isDraggingDown {
                    changeModalHeight(ModalHeight.median.height)
                } else {
                    changeModalHeight(ModalHeight.maximum.height)
                }
            }
        default:
            break
        }
    }
}
