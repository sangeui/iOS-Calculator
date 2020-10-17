//
//  Double+length.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/08.
//

protocol Number  {}
extension Number where Self: Numeric {
    var toString: String {
        return "\(self)"
    }
}
extension Number where Self: Comparable {
    func isEqual(to number: Self) -> Bool {
        return self == number
    }
    func isGreaterThanOrEqual(to number: Self) -> Bool {
        return self >= number
    }
    func isLessThanOrEqual(to number: Self) -> Bool {
        return self <= number
    }
}
extension Int: Number {}
//extension Double: Number {}
extension Double {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ?
        String(format: "%.0f", self) :
        String(self)
    }
    var length: Int { return String(self).count - 1 }
    var isNegative: Bool { return self < 0 }
    var isPositive: Bool { return self > 0 }
    var getLengthofIntegerPart: Int {
        let absoluteDouble = abs(self).rounded(.down)
        let integerPart = absoluteDouble.truncatingRemainder(dividingBy: 1) == 0 ?
        String(format: "%.0f", absoluteDouble) : String(absoluteDouble)
        return integerPart.count
    }
}
