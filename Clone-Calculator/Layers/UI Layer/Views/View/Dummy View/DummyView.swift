//
//  DummyView.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/16.
//

import UIKit

class DummyView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return superview
    }
}
