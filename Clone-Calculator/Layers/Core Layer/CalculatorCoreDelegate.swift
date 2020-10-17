//
//  CoreDelegateProtocol.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/15.
//

protocol CalculatorCoreDelegate: class {
    func getUrgentEvaluatedValue(_ value: Double)
    func getUrgentReplaceableValue(_ value: Double)
}
