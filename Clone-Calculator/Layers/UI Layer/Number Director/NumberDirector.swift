//
//  NumberBuilder.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/10.
//

import Foundation

// 연속된 숫자의 입력을 처리하는 책임을 가짐.

class NumberDirector {
    var builder: Builder<String>
    
    private var isNegativeFormat: Bool = false
    private var isDecimalFormat: Bool = false
    private var isEnteredZeroFromUser: Bool = false
    private var isMaximum: Int {
        self.builder.get().filter {
            ($0 != Symbols.DecimalPoint) && ($0 != Symbols.Minus) }
            .count
    }
    
    private var operand: String = ""
    
    required init(builder: Builder<String>) {
        self.builder = builder
    }
    
    func receiveMinusSign() {
        isNegativeFormat = isNegativeFormat ? false : true
    }
    func receiveDeciamlSeparator() {
        guard isDecimalFormat else { setDecimalFormat(); return }
        if checkIfLastIsDecimalPoint() { releaseDecimalFormat(); return }
    }
    func receiveNumber(_ number: String) {
        if isMaximum == 9 { return }
        if number == "0" { isEnteredZeroFromUser = true }
        if isStartingState { replaceFirstDigit(with: number) }
        else {
            builder.add(element: number)
        }
    }
    func receiveBuildingOperand() -> String {
        defer { prepareStartingState() }
        if prepareSendingOperand() { setNegativeFormatIfNeeded() }
        return operand
    }
    func receiveClear() {
        prepareStartingState()
    }
    func receiveBorrowingOperand() -> String {
        defer { operand = "" }
        prepareShowingOperand()
        setNegativeFormatIfNeeded()
        return operand
    }
}
private extension NumberDirector {
    var isStartingState: Bool {
        return builder.count == 1 && builder.peak()! == "0"
    }
    func prepareShowingOperand() {
        operand = builder.get().joined()
    }
    func prepareSendingOperand() -> Bool {
        if isStartingState {
            if isEnteredZeroFromUser {
                operand = builder.build().joined()
                return true
            } else { return false }
        } else {
            operand = builder.build().joined()
            return true
        }
    }
    func setNegativeFormatIfNeeded() {
        if isNegativeFormat {
            operand =  "-" + operand
        }
    }
    func prepareStartingState() {
        builder.clear()
        builder.add(element: "0")
        
        operand = ""
        isNegativeFormat = false
        isDecimalFormat = false
        isEnteredZeroFromUser = false
    }
    func replaceFirstDigit(with number: String) {
        builder.remove()
        builder.add(element: number)
    }
    func setDecimalFormat() {
        isDecimalFormat = true
        builder.add(element: Symbols.DecimalPoint)
    }
    func releaseDecimalFormat() {
        isDecimalFormat = false
        builder.remove()
    }
    func checkIfLastIsDecimalPoint() -> Bool {
        guard let last = builder.peak() else { return false }
        return last == Symbols.DecimalPoint
    }
    func isBuilderEmpty() -> Bool {
        return builder.peak() == nil
    }
}
struct Symbols {
    static let DecimalPoint = "."
    static let Minus = "-"
}
