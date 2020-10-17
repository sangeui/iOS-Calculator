//
//  TestView.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/16.
//

import UIKit

class BottomView: UIView {
    private var test: CalculatorButton?
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        subviews.forEach{
            if let subview = $0.hitTest(touches.first!.location(in: $0), with: event),
               let button = subview as? CalculatorButton {
                test = button
                button.sendActions(for: .touchDragEnter)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        subviews.forEach{
            if let subview = $0.hitTest(touches.first!.location(in: $0), with: event),
               let button = subview as? CalculatorButton {
                if let testview = test, testview != button {
                    testview.sendActions(for: .touchDragExit)
                    testview.touchUp()
                    test = nil
                } else {
                    button.touchDown()
                    button.sendActions(for: .touchDragEnter)
                    test = button
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let testview = test {
            testview.sendActions(for: .touchUpInside)
        }
    }
}
