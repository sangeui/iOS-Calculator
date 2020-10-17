//
//  CircleButton.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/03.
//

import UIKit

@IBDesignable class CalculatorButton: UIButton {
    @IBInspectable private var isCircle: Bool = false { didSet { handleBasedIsCircle() } }
    @IBInspectable private var labelValue: String = "" { didSet { setupLabelText(labelValue) } }
    @IBInspectable private var labelColor: UIColor = .white { didSet { handleWhenLabelColorIsSet() } }
    @IBInspectable private var brightness: CGFloat = 70
    @IBInspectable private var colorWhenPressed: UIColor?
    @IBInspectable private var isZeroButton: Bool = false { didSet { layoutLabel() }}
    
    override var isSelected: Bool { didSet { handleBasedIsSelected() } }
    
    private var originalColor: UIColor?
    private var originalTextColor: UIColor?
    private var animator = UIViewPropertyAnimator()
    private var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    func setButtonValue(_ string: String) {
        self.labelValue = string
    }
    func getButtonValue() -> String {
        return labelValue
    }
    func forceToDeselect() {
        self.isSelected = false
    }
}
private extension CalculatorButton {
    func makeAnimatorBasedIsSelected() {
        animator = isSelected ?
            makeAnimator(with: updateWhenIsSelected) :
            makeAnimator(with: updateWhenIsDeselected)
    }
    func updateWhenIsSelected() {
        setupLabelColor(originalColor)
        setupBackground(.white)
    }
    
    func handleWhenLabelColorIsSet() {
        setupLabelColor(labelColor)
        saveTextColor(labelColor)
    }
    func handleBasedIsCircle() {
        if isCircle { setupDefaultCornerRadius() }
    }
    func handleBasedIsSelected() {
        if animator.isRunning { stopAnimation(true) }
        updateBasedIsSelected()
    }
    func updateWhenIsDeselected() {
        setupLabelColor(originalTextColor)
        setupBackground(originalColor)
    }
    func updateBasedIsSelected() {
        makeAnimatorBasedIsSelected()
        startAnimation()
    }
}

private extension CalculatorButton {
    func startAnimation() {
        animator.startAnimation()
    }
    func stopAnimation(_ bool: Bool) {
        animator.stopAnimation(bool)
    }
    func setupLabelColor(_ color: UIColor?) {
        label.textColor = color
    }
    func setupLabelText(_ text: String) {
        label.text = text
    }
    func setupBackground(_ color: UIColor?) {
        backgroundColor = color
    }
    func setupDefaultCornerRadius() {
        layer.cornerRadius = frame.height / 2 - 5
    }
    func saveBackgroundColor() {
        self.originalColor = backgroundColor ?? .clear
    }
    func saveTextColor(_ color: UIColor?) {
        self.originalTextColor = color
    }
    func makeAnimator(with animation: (() -> Void)?) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: animation)
    }
}
// MARK: - Setup Methods
private extension CalculatorButton {
    func setup() {
        self.tintColor = .clear
        saveBackgroundColor()
        setupInteraction()
        setupLabel()
    }
    func setupInteraction() {
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
    }
    func setupLabel() {
        self.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    func layoutLabel() {
        if isZeroButton {
            NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30)
            ])
        } else {
            NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                label.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        }
    }
}
// MARK: - Action Methods
extension CalculatorButton {
    @objc func touchDown() {
        stopAnimation(true)
        setupBackground(colorWhenPressed)
        setupBackground(colorWhenPressed ?? originalColor?.lighter(by: brightness))
    }
    @objc func touchUp() {
        makeAnimatorBasedIsSelected()
        startAnimation()
    }
}
