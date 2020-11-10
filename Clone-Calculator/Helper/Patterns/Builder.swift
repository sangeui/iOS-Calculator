//
//  Builder.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/09/29.
//

import Foundation

class Builder<Element> {
    private var elements: [Element] = []
    
    var count: Int { return elements.count }
    
    func add(element: Element) {
        self.elements.append(element)
    }
    @discardableResult
    func remove() -> Element? {
        return elements.popLast()
    }
    func build() -> [Element] {
        defer { clear() }
        return elements
    }
    func clear() {
        elements.removeAll()
    }
    func peak() -> Element? {
        elements.last
    }
    func get() -> [Element] {
        return elements
    }
    func insert(_ element: Element, at index: Int) {
        guard index < elements.count else { return }
        if count == 0 {
            elements.append(element)
        } else {
            elements.insert(element, at: index)
        }
    }
}
typealias Expression = [Token]
class ExpressionBreaker {
    func check(_ firstToken: Token, _ secondToken: Token) -> Bool {
        guard let firstOperator = firstToken.extractOperator,
              let secondOperator = secondToken.extractOperator else {
            return false
        }
        
        return firstOperator.isGreaterThanOrEqual(with: secondOperator)
    }
}
