//
//  History.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/15.
//

import Foundation

struct History {
    private var mostRecentReceivedOperand: Token?
    private var mostRecentReceivedOperator: Token?
    private var mostRecentReceived: Token?
    private var mostRecentUsedOperator: Token?
    private var mostRecentUsedOperand: Token?
    private var mostRecentEvaluated: EvaluatedDouble?
    
    private var temp: EvaluatedDouble?
    
    mutating func setReceivedToken(_ token: Token) {
        classifyAndSetToken(token)
        mostRecentReceived = token
    }
    mutating func setEvaluatedInformation(_ information: InformationEvaluated) {
        mostRecentEvaluated = information.result
        mostRecentUsedOperator = information.operator
        mostRecentUsedOperand = information.operand
    }
    func getLastToken() -> Token? {
        return mostRecentReceived
    }
    func getLastOperand() -> Token? {
        return mostRecentReceivedOperand
    }
    func getLastOperator() -> Token? {
        return mostRecentReceivedOperator
    }
    func getLastEvaluatedOperand() -> Token? {
        return mostRecentUsedOperand
    }
    func getLastEvaluatedOperator() -> Token? {
        return mostRecentUsedOperator
    }
    func getLastEvaluatedResult() -> EvaluatedDouble? {
        return mostRecentEvaluated
    }
    mutating private func classifyAndSetToken(_ token: Token) {
        if token.isOperator {
            mostRecentReceivedOperator = token
        } else if token.isOperand {
            mostRecentReceivedOperand = token
        }
    }
    mutating private func reset() {
        mostRecentReceivedOperand = nil
        mostRecentReceivedOperator = nil
        mostRecentReceived = nil
        mostRecentUsedOperator = nil
        mostRecentUsedOperand = nil
        temp = mostRecentEvaluated
        mostRecentEvaluated = nil
    }
}
