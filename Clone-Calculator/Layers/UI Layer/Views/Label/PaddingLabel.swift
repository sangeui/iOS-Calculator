//
//  PaddingLabel.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/12.
//

import UIKit

@IBDesignable class PaddingLabel: UILabel {
    @IBInspectable var verticalPadding: CGFloat = 5.0
    @IBInspectable var horizontalPadding: CGFloat = 7.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        super.drawText(in: rect.inset(by: insets))
    }
    override var intrinsicContentSize: CGSize {
            let size = super.intrinsicContentSize
            return CGSize(width: size.width + (horizontalPadding * 2),
                          height: size.height + (verticalPadding * 2))
        }

        override var bounds: CGRect {
            didSet {
                // ensures this works within stack views if multi-line
                preferredMaxLayoutWidth = bounds.width - (horizontalPadding * 2)
            }
        }
}
extension PaddingLabel {
    override var canBecomeFirstResponder: Bool { return true }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(copy(_:))
    }
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
    }
}
