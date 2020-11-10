//
//  Refinery.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/08.
//

import Foundation

// 계산된 Double 타입의 결과를 적절한 형태로 정제하는 책임을 가짐.

class NumberRefinery {
    typealias Lengths = (integer: Int, fraction: Int)
    private let MaxLength: Int
    private let decimalFormatter: (Int?) -> NumberFormatter = { limit in
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let limit = limit { formatter.maximumFractionDigits = limit }
        return formatter
    }
    private let scientificFormatter: (Int?) -> NumberFormatter = { limit in
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        if let sharpsCount = limit {
            let sharps = String(repeating: "#", count: sharpsCount)
            formatter.positiveFormat = "0.\(sharps)E0"
        }
        return formatter
    }
    private let converter: (Int) -> NumberFormatter = { digit in
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = digit
        formatter.maximumFractionDigits = digit
        return formatter
    }
    
    init(_ limit: Int) {
        self.MaxLength = limit
    }
    func convert(_ number: String) -> RefinedString {
        let numberInDouble = Double(number)!
        let lengths = getEachLengthOfNumber(number)
        return converter(lengths.fraction).string(from: NSNumber(value: numberInDouble))!
    }
    func refine(_ evaluated: EvaluatedDouble) -> RefinedString {
        return isPossibleMakingDecimalFormat(evaluated) ? makeDecimalFormattedString(evaluated) : makeScientificFormattedString(evaluated)
    }
}
private extension NumberRefinery {
    func getEachLengthOfNumber(_ number: String) -> Lengths {
        let numberinDouble = Double(number)!
        let integerPart = numberinDouble.getLengthofIntegerPart
        var frctionPart = number.count - integerPart - Symbols.DecimalPoint.count
        if numberinDouble.isNegative { frctionPart -= Symbols.Minus.count }
        return (integerPart, frctionPart)
    }
    func isPossibleMakingDecimalFormat(_ number: Double) -> Bool {
        let length = String(abs(number)).count - 1
        if length.isLessThanOrEqual(to: MaxLength) { return true }
        if number.getLengthofIntegerPart.isLessThanOrEqual(to: MaxLength) {
            let test = decimalFormatter(MaxLength-1).string(from: NSNumber(value: number))!
            if let test = Double(test), test.isZero { return false }
            else { return true }
        }
        return false
    }
    func getLengthOfFraction(_ number: Double) -> Int {
        return MaxLength - number.getLengthofIntegerPart
    }
    func makeScientificFormattedString(_ number: Double) -> RefinedString {
        let test = decimalFormatter(MaxLength-1).string(from: NSNumber(value: number))!
        if let test = Double(test), test.isZero {
            let limit = MaxLength - String(number.getLengthofIntegerPart-1).count - 3
            return generateScientificFormat(from: number, limit: limit)
        } else {
            let limit = MaxLength - String(number.getLengthofIntegerPart-1).count - 2
            return generateScientificFormat(from: number, limit: limit)
        }
    }
    func makeDecimalFormattedString(_ number: Double) -> RefinedString {
        if number.length.isLessThanOrEqual(to: MaxLength) {
            return generateDeicmalFormat(from: number, limit: MaxLength)
        } else {
            let limit = getLengthOfFraction(number)
            return generateDeicmalFormat(from: number, limit: limit)
        }
    }
    func generateScientificFormat(from number: Double, limit: Int) -> String {
        return scientificFormatter(limit).string(from: NSNumber(value: number))!
    }
    func generateDeicmalFormat(from number: Double, limit: Int) -> String {
        return decimalFormatter(limit).string(from: NSNumber(value: number))!
    }
}
