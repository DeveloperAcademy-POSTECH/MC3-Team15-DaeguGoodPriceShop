//
//  DetailModalViewController.swift
//  DaeguGoodPriceShop
//
//  Created by Yeongwoo Kim on 2022/07/10.
//

import UIKit

class DetailModalViewController: ModalViewController {
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
        let defaultViewController = self.parent?.children.first(where: { $0 is DefaultModalViewController }) as! DefaultModalViewController
        
        switch gesture.state {
        case .changed:
            if newHeight < ModalHeight.median.height {
                modalHeight?.constant = newHeight
                parent?.view.layoutIfNeeded()
                defaultViewController.modalHeight?.constant = newHeight
                parent?.view.layoutIfNeeded()
            } else if newHeight < ModalHeight.maximum.height {
                modalHeight?.constant = newHeight
                parent?.view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < ModalHeight.median.height {
                if isDraggingDown {
                    changeModalHeight(ModalHeight.minimum.height)
                    defaultViewController.changeModalHeight(ModalHeight.minimum.height)
                } else {
                    changeModalHeight(ModalHeight.median.height)
                    defaultViewController.changeModalHeight(ModalHeight.median.height)
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

