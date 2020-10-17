//
//  CircleButton.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/03.
//

import UIKit

@IBDesignable class CalculatorButton: UIButton {
    @IBInspectable var onoff: Bool = false {
        didSet {
            if onoff { layer.cornerRadius = self.frame.height / 2 }
        }
    }
    @IBInspectable var value: Int = 0 {
        didSet {
        }
    }
    
    private var label = UILabel()
    private var originalColor: UIColor?
    private var animator = UIViewPropertyAnimator()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.originalColor = backgroundColor ?? .clear
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
    }
    
    @objc private func touchDown() {
        animator.stopAnimation(true)
        self.backgroundColor = originalColor?.colorWithBrightness(brightness: 1.25)
    }
    @objc private func touchUp() {
        animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: {
            self.backgroundColor = self.originalColor
        })
        animator.startAnimation()
    }
}
extension CalculatorButton {
    
}
public extension UIColor {
    func colorWithBrightness(brightness: CGFloat) -> UIColor {
        var H: CGFloat = 0, S: CGFloat = 0, B: CGFloat = 0, A: CGFloat = 0
        
        if getHue(&H, saturation: &S, brightness: &B, alpha: &A) {
            B += (brightness - 1.0)
            B = max(min(B, 1.0), 0.0)
            
            return UIColor(hue: H, saturation: S, brightness: B, alpha: A)
        }
        
        return self
    }
}
