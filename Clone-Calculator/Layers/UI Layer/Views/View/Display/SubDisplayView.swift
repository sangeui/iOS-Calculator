//
//  NotificationView.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/10.
//

import UIKit

class SubDisplayView: UIView {
    private let rgb: CGFloat = 0.08
    private let scrollView = UIScrollView()
    private let messageView = UILabel()
    private var message = "" {
        didSet {
            if message.isEmpty {
                messageView.text = "비어있습니다."
            } else {
                let test = message.reduce(NSMutableAttributedString()) {
                    $0.append(
                        NSAttributedString(
                            string: String($1),
                            attributes: [
                                .foregroundColor: ($1 == "(") || ($1 == ")") ? UIColor.darkGray : .white
                            ]
                        )
                    )
                    return $0
                }
                messageView.attributedText = test
            }

        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func message(_ message: String) {
        DispatchQueue.main.async { self.message = message }
    }
    
    private func setup() {
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor(red: rgb, green: rgb, blue: rgb, alpha: 1.0)
        
        messageView.textColor = .lightGray
        scrollView.backgroundColor = .clear
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        self.addSubview(scrollView)
        scrollView.addSubview(messageView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            
            messageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            messageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
            scrollView.contentLayoutGuide.leadingAnchor.constraint(equalTo: messageView.leadingAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: messageView.trailingAnchor),
            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: messageView.topAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: messageView.bottomAnchor)
        ])
    }
}
extension SubDisplayView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            return nil
        }
        return hitView
    }
}
extension UIView {
    func blink() {
        UIView.animate(withDuration: 0.5, //Time duration you want,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse],
            animations: {
                [weak self] in self?.alpha = 0.0
            }, completion: {
                [weak self] _ in self?.alpha = 1.0
            })
    }

    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
}

