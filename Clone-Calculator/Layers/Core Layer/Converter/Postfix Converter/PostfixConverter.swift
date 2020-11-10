//
//  PostfixConverter.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/11/10.
//

import Foundation

class PostfixConverter: Converter {
    var temp_buffer: [Operator] = []
    var result_buffer: Expression = []
    func clear() {
        self.temp_buffer.removeAll()
        self.result_buffer.removeAll()
    }
    func convert(_ expression: Expression) -> Expression {
        defer {
            temp_buffer.removeAll()
            result_buffer.removeAll()
        }
        expression.forEach(handleToken(_:))
        temp_buffer.reversed().forEach {
            result_buffer.append(Token(operator_type: $0.type))
        }
        return result_buffer
    }
    private func handleToken(_ token: Token) {
        if let newoperator = token.extractOperator {
            for recentoperator in temp_buffer.reversed() {
                if (newoperator.associativity == .Left &&
                   newoperator.precedence <= recentoperator.precedence) ||
                    (newoperator.associativity == .Right && newoperator.precedence < recentoperator.precedence) {
                    let removed = temp_buffer.removeLast()
                    result_buffer.append(Token(operator_type: removed.type))
                } else {
                    break
                }
            }
            
            temp_buffer.append(newoperator)
        } else if let _ = token.extractOperand {
            result_buffer.append(token)
        }
    }
    // MARK: - Converting infix to postfix
    /*
     1. 모든 입력 토큰들에 대해서
        1.1. 다음 토큰을 읽는다.
        1.2. [조건 1]: 토큰이 연산자일 때 (x)
            1.2.1. [반복] 연산자 스택의 최상위 연산자 (y)가 존재할 때, `x`가 `left associative` 이면서 이 우선순위가 `y` 보다 작거나 같을 때, 또는 `x`가 `right associative` 이면서 이 우선순위가 `y` 보다 작다면
                1.2.1.1. 스택에서 `y` 를 꺼내 출력 버퍼에 넣는다.
            1.2.2. `x` 를 스택에 넣는다.
        1.3. [조건 2]: 토큰이 여는 괄호일 때
            1.3.1. 연산자 스택에 넣는다.
        1.4. [조건 3]: 토큰이 닫는 괄호일 때
            1.4.1. [반복] 연산자 스택의 최상위 토큰이 여는 괄호가 될 때까지
                1.4.1.1. 스택에서 토큰을 꺼내 출력 버퍼에 넣는다.
            1.4.2. 여는 괄호도 스택에서 꺼내지만 이를 출력 버퍼에 넣지는 않는다.
        1.5. [조건 4]: 이 외의 경우
            1.5.1. 토큰을 출력 버퍼에 넣는다.
     2. 스택에 남아 있는 모든 연산자를 출력 버퍼에 넣는다.
     */
}
