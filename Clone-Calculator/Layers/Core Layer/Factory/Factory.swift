//
//  Factory.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/02.
//

import Foundation

class TokenFactory {
    private let OPERAND = true, OTHERS = false
    private let OPERATOR = true, BRACKET = false
    private let OPEN_BRACKET = "(", CLOSE_BRACKET = ")"
    func create(_ value: String) -> Token {
        if isOperand(value) { return createOperandToken(value) }
        else if isHalfOperator(value) { return createHalfOperatorToken(value)}
        else if isOperator(value) { return createOperatorToken(value) }
        else { return createBracket(value) }
    }
}
private extension TokenFactory {
    func createBracket(_ bracket: String) -> Token {
        return Token(bracket: Bracket(rawValue: bracket)!)
    }
    func createOperatorToken(_ _operator: String) -> Token {
        return Token(operator_type: OperatorType(rawValue: _operator)!)
    }
    func createOperandToken(_ operand: String) -> Token {
        return Token(operand: Double(operand)!)
    }
    func createHalfOperatorToken(_ halfOperator: String) -> Token {
        return Token(halfOperator: HalfOperatorType(rawValue: halfOperator)!)
    }
    func isHalfOperator(_ input: String) -> Bool {
        return HalfOperatorType(rawValue: input) != nil
    }
    func isOperand(_ input: String) -> Bool {
        if Double(input) != nil { return true }
        else { return false }
    }
    func isOperator(_ input: String) -> Bool {
        return
            !input.isEqual(with: OPEN_BRACKET) ||
            !input.isEqual(with: CLOSE_BRACKET)
    }
}
