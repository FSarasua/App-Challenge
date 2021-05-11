//
//  UIScrollView+Extension.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 08/05/2021.
//

import Foundation
import UIKit

extension UIScrollView {
    
    func scrollTo(view: UIView, hasToolBar: Bool, animated: Bool) {

        if let origin = view.superview {
            let startPointY = origin.convert(view.frame.origin, to: self).y
            let keyboardHeight = (UIScreen.main.bounds.size.height / UIDevice.keyboardMultiplier) + (hasToolBar ? Constants.Constraints.pickerToolbarHeight : 0.0)
            let marginBottom: CGFloat = 16.0
            let restFrameY = self.frame.height - keyboardHeight
            
            var newY = startPointY + view.frame.height + marginBottom - restFrameY
            
            if newY < 0 {
                newY = 0.0
            }
            
            UIView.animate(withDuration: 0.6) {
                self.contentOffset = CGPoint(x: self.contentOffset.x, y: newY)
                self.layoutIfNeeded()
            }
        }
    }
}
