//
//  TestView.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/16.
//

import UIKit

protocol ButtonsViewDelegate: class {
    func sendSelectedButton(_ button: CalculatorButton)
}

class ButtonsView: UIView {
    weak var delegate: ButtonsViewDelegate?
    private var buttonTracked: CalculatorButton?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        subviews.forEach{ handleSubviewWhenTouchBegan($0, point: touches.first?.location(in: $0), event: event) }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        subviews.forEach{ handleSubviewWhenTouchMoved($0, point: touches.first?.location(in: $0), event: event) }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let oldbutton = buttonTracked {
            setupButtonAsSelected(oldbutton)
        }
    }
}
private extension ButtonsView {
    func handleSubviewWhenTouchBegan(_ subview: UIView, point: CGPoint?, event: UIEvent?) {
        guard let point = point else { return }
        if let subview = subview.hitTest(point, with: event),
           let button = subview as? CalculatorButton {
            setupButtonAsSwipedIn(button)
        }
    }
    func handleSubviewWhenTouchMoved(_ subview: UIView, point: CGPoint?, event: UIEvent?) {
        guard let point = point else { return }
        if let subview = subview.hitTest(point, with: event),
           let button = subview as? CalculatorButton {
            if let oldbutton = buttonTracked, oldbutton != button {
                setupButtonAsSwipedOut(oldbutton)
            } else {
                setupButtonAsSwipedIn(button)
            }
        }
    }
    func setupButtonAsSwipedOut(_ button: CalculatorButton) {
        button.sendActions(for: .touchDragExit)
        buttonTracked = nil
    }
    func setupButtonAsSwipedIn(_ button: CalculatorButton) {
        button.sendActions(for: .touchDragEnter)
        buttonTracked = button
    }
    func setupButtonAsSelected(_ button: CalculatorButton) {
        button.sendActions(for: .touchUpInside)
        delegate?.sendSelectedButton(button)
    }
}
