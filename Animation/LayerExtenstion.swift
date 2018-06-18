//
//  LayerExtenstion.swift
//  Animation
//
//  Created by Eli Slade on 2018-06-16.
//  Copyright © 2018 Eli Slade. All rights reserved.
//

import UIKit

protocol CALayerBacked {
    var layer:CALayer { get }
}

extension CALayerBacked {
    func cornerRadius(_ value:CGFloat) {
        layer.cornerRadius = value
    }
    
    func shadow(x:CGFloat, y:CGFloat, color:UIColor) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
    }
}

extension UIView: CALayerBacked {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
