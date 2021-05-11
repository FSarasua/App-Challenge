//
//  UIDevice+Extension.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 11/05/2021.
//

import Foundation
import UIKit

extension UIDevice {
    
    static var keyboardMultiplier: CGFloat {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return 2.59 }
        
        if UIDevice.current.orientation.isPortrait && window.safeAreaInsets.top >= 44 {
            return 2.59
        } else if UIDevice.current.orientation.isLandscape && (window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0) {
            return 2.3
        }
        
        return 2.59
    }
}
