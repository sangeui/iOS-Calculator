//
//  ExpressionBuilder.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/17.
//

import Foundation

class ExpressionBuilder: Builder<Token> {
    private var needsCloseBracket = false
    
    override func add(element: Token) {
        super.add(element: element)
        if needsCloseBracket {
            needsCloseBracket = false
            super.add(element: .init(bracket: .Closed))
        }
    }
    func setNeedsCloseBracket() {
        if let peaked = get()[count-2].extractBracket, peaked == .Closed {
            return
        }
        needsCloseBracket = true
        super.insert(.init(bracket: .Open), at: count-2)
    }
}
