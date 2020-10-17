//
//  String+Extension.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/06.
//

extension String {
    func isNegativeNumberString() -> Bool {
        guard let number = Double(self) else { return false }
        return number < 0
    }
    func isEqual(with string: String) -> Bool {
        return self == string
    }
    func isShorterThanOrEqual(with length: Int) -> Bool {
        return self.count <= length
    }
    func lastCharacter(is string: Character) -> Bool {
        if let last = self.last, last == string { return true }
        else { return false }
    }
}
