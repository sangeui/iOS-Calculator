//
//  Operator_Type.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/09/28.
//

import Foundation


enum OperatorAssociativity {
    case Right, Left
}
// MARK: - Token_OperatorType
enum OperatorType: String {
    case Add = "+",
         Subtract = "−",
         Divide = "÷",
         Multiply = "×",
         Exponent = "^"
}

// MARK: - Token_OperatorType_precedence
extension OperatorType {
    var precedence: Int {
        switch self {
        case .Add, .Subtract:
            return 0    // Row Precedence
        case .Divide, .Multiply:
            return 5    // Middle Precedence
        case .Exponent:
            return 10   // High Precedence
        }
    }
}
// MARK: - Token_OperatorType_associativity
extension OperatorType {
    var associativity: OperatorAssociativity {
        switch self {
        case .Add, .Subtract, .Divide, .Multiply:
            return .Left
        case .Exponent:
            return .Right
        }
    }
}
