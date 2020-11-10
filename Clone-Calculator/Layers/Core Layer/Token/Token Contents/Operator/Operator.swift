//
//  Operator.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/09/23.
//

struct Operator {
    var type: OperatorType
    var associativity: OperatorAssociativity
    var precedence: Int
    
    init(type: OperatorType) {
        self.type = type
        self.associativity = type.associativity
        self.precedence = type.precedence
    }
    func isHigher(than another: Operator) -> Bool {
        return self.precedence > another.precedence
    }
    func isGreaterThanOrEqual(with another: Operator) -> Bool {
        return self.precedence >= another.precedence
    }
    func calculate(_ first: Double, _ second: Double) -> Double {
        switch self.type {
        case .Add:
            return first + second
        case .Subtract:
            return first - second
        case .Multiply:
            return first * second
        case .Divide:
            return first / second
        default:
            return 1.0
        }
    }
}

