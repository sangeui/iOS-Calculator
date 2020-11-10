//
//  HalfOperator.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/15.
//

struct HalfOperator {
    var type: HalfOperatorType
    
    init(type: HalfOperatorType) {
        self.type = type
    }
    func calculate(number: Double, ratio: Double = 1) -> Double {
        switch self.type {
        case .Percent: return number * 0.01
        }
    }
}
