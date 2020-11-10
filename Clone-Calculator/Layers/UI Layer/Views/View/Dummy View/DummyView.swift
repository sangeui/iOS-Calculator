//
//  DummyView.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/16.
//

import UIKit

// 터치 이벤트를 슈퍼 뷰로 바로 보냄.

class DummyView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return superview
    }
}
