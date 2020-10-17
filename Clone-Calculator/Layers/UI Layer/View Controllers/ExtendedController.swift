//
//  ExtendedController.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/17.
//

import UIKit

class ExtendedController: BaseController {
    
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var buttonsView: ButtonsView!
    @IBOutlet weak var subDisplayTop: NSLayoutConstraint!
    
    private var selectedButton: CalculatorButton?
    
    override func viewDidLoad() {
        buttonsView.delegate = self
        setupCustomGestures()
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        addMenuObserverNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        removeMenuObserverNotification()
    }
    
    override func actionForNumberButton(_ sender: UIButton) {
        makeButtonDeselect(sender as? CalculatorButton)
        super.actionForNumberButton(sender)
    }
    override func actionForOperatorButton(_ sender: UIButton) {
        makeButtonDeselect(sender as? CalculatorButton)
        makeButtonSelected(sender as? CalculatorButton)
        super.actionForOperatorButton(sender)
    }
    override func actionForEqualButton(_ sender: UIButton) {
        makeButtonDeselect()
        super.actionForEqualButton(sender)
    }
    override func actionForShowButton(_ sender: UIButton) {
        makeSubDisplayDropdown()
        super.actionForShowButton(sender)
    }
    override func deepClear() {
        makeButtonDeselect()
        super.deepClear()
    }
}
private extension ExtendedController {
    func makeSubDisplayDropdown() {
        subDisplay.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.subDisplayTop.constant = 20
            self.view.layoutIfNeeded()
        }
    }
    func setupCustomGestures() {
        makeLongPressibleView()
        makeSwipableView()
    }
    func makeLongPressibleView() {
        let longPress = makeLongPressAction(with: #selector(longPress(_:)))
        displayView.addGestureRecognizer(longPress)
    }
    func makeSwipableView() {
        let swipeToUp = makeSwipeAction(with: #selector(swipeUpSubDisplay(_:)))
        swipeToUp.direction = .up
        subDisplay.addGestureRecognizer(swipeToUp)
    }
    func makeButtonSelected(_ newButton: CalculatorButton?) {
        if let newbutton = newButton {
            newbutton.isSelected = true
            selectedButton = newbutton
        }
    }
    func makeButtonDeselect(_ newButton: CalculatorButton? = nil) {
        if let newbutton = newButton, newbutton == selectedButton { return }
        if let oldbutton = selectedButton {
            oldbutton.forceToDeselect()
            selectedButton = nil
        }
    }
}
// MARK: - Notification Center
private extension ExtendedController {
    private func removeMenuObserverNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    private func addMenuObserverNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(willShowMenu), name: UIMenuController.willShowMenuNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideMenu), name: UIMenuController.willHideMenuNotification, object: nil)
    }
    @objc func willShowMenu() {
        mainDisplay.backgroundColor = UIColor(named: "Custom_DarkGray")
    }
    @objc func willHideMenu() {
        mainDisplay.backgroundColor = .clear
    }
}
// MARK: - Action Methods
private extension ExtendedController {
    func makeLongPressAction(with action: Selector?) -> UILongPressGestureRecognizer {
        return UILongPressGestureRecognizer(target: self, action: action)
    }
    func makeSwipeAction(with action: Selector?) -> UISwipeGestureRecognizer {
        return UISwipeGestureRecognizer(target: self, action: action)
    }
    @objc func swipeUpSubDisplay(_ recognizer: UISwipeGestureRecognizer) {
        if let _ = recognizer.view {
            UIView.animate(withDuration: 0.3) {
                self.subDisplayTop.constant = -150
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func longPress(_ recognizer: UIGestureRecognizer) {
        if let recognizedView = recognizer.view,
           recognizer.state == .began {
            mainDisplay.becomeFirstResponder()
            UIMenuController.shared.showMenu(from: recognizedView, rect: mainDisplay.frame)
        }
    }
}
extension ExtendedController: ButtonsViewDelegate {
    func sendSelectedButton(_ button: CalculatorButton) {
        if ["+", "−", "÷", "×"].contains(button.getButtonValue()) {
            selectedButton = button
        }
    }
}
extension UISwipeGestureRecognizer {
    func setDirection(to direction: Direction) {
        self.direction = direction
    }
}
