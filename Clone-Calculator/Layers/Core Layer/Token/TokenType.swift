//
//  TokenType.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/15.
//

enum TokenType {
    case Operand(Double)
    case Operator(Operator)
    case Bracket(Bracket)
    case HalfOperator(HalfOperator)
}
