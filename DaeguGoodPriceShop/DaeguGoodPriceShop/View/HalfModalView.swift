//
//  HalfModalView.swift
//  DaeguGoodPriceShop
//
//  Created by Yeongwoo Kim on 2022/07/07.
//

import Foundation
import UIKit

extension MapViewController {
    @IBAction func buttonClicked(_ sender: Any) {
        changeModalHeight(defaultHeight)
    }
    
    func changeModalHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.modalHeight.constant = height
            self.view.layoutIfNeeded()
        }
        
        currentHeight = height
    }
    
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        gestureView.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown = translation.y > 0
        let newHeight = currentHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < fullHeight {
                modalHeight.constant = newHeight
                modalView.layoutIfNeeded()
            }
        case .ended:
            if newHeight < defaultHeight && isDraggingDown {
                changeModalHeight(minimumHeight)
            }
            else if newHeight < defaultHeight {
                changeModalHeight(defaultHeight)
            }
            else if newHeight < fullHeight && isDraggingDown {
                changeModalHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                changeModalHeight(fullHeight)
            }
        default:
            break
        }
    }
}

