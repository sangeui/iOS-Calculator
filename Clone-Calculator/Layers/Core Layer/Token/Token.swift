//
//  Token.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/09/23.
//

import Foundation

// MARK: - Token
struct Token {
    var content: TokenType
    
    // MARK: - Token Initializer
    init(halfOperator: HalfOperatorType) {
        content = .HalfOperator(HalfOperator(type: halfOperator))
    }
    // Init: Operand
    init(operand: Double) {
        content = .Operand(operand)
    }
    // Init: Operator
    init(operator_type: OperatorType) {
        content = .Operator(Operator(type: operator_type))
    }
    // Init: Bracket
    init(bracket: Bracket) {
        content = .Bracket(bracket)
    }
}
extension Token: CustomStringConvertible {
    var description: String {
        switch content {
        case let TokenType.Operator(extracted):
            return extracted.type.rawValue
        case let TokenType.Operand(extracted):
            return "\(extracted)"
        case let TokenType.Bracket(bracket):
            return "\(bracket.rawValue)"
        case let TokenType.HalfOperator(halfOperator):
            return "\(halfOperator.type.rawValue)"
        }
    }
}
extension Token {
    var isOperator: Bool { return extractOperator != nil }
    var isOperand: Bool { return extractOperand != nil }
    
    var extractHalfOperator: HalfOperator? {
        if case let TokenType.HalfOperator(extract) = content {
            return extract
        } else { return nil }
    }
    var extractOperator: Operator? {
        if case let TokenType.Operator(extracted) = content {
            return extracted
        } else { return nil }
    }
    var extractOperand: Double? {
        if case let TokenType.Operand(extracted) = content {
            return extracted
        } else { return nil }
    }
    var extractBracket: Bracket? {
        if case let TokenType.Bracket(extracted) = content {
            return extracted
        } else { return nil }
    }
}
