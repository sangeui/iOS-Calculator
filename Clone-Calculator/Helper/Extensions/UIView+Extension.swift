//
//  UIView+Extension.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/15.
//

import UIKit

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-10.0, 10.0, -8.0, 8.0, -6.0, 6.0, -4.0, 4.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
@IBDesignable
extension UIView {
    @IBInspectable
    public var cornerRadius: CGFloat {
        set (radius) {
            self.layer.cornerRadius = radius
            self.layer.masksToBounds = radius > 0
        }

        get { return self.layer.cornerRadius }
    }
}
