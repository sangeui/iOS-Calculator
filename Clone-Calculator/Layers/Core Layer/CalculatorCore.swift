//
//  AppModel.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/09/23.
//

import Foundation

class CalculatorCore {
    typealias EvaluatedInDouble = Double
    
    public weak var delegate: CalculatorCoreDelegate?

    private let factory = TokenFactory()
    private let checker = ExpressionBreaker()
    private let converter: Converter = PostfixConverter()
    private let evaluator = PostfixEvaluator()
    private var history = History()
    
    private let buildingExpression = Builder<Token>()
    private let completeExpression = ExpressionBuilder()
    
    private var mostRecentOperandToken: Token?
    private var mostRecentOperatorToken: Token?
    private var mostRecentToken: Token?
    
    private var isEvaluating: Bool = false
    private var evaluatedOperator: Token?
    private var evaluatedOperand: Token?
    private var mostRecentEvaluated: EvaluatedInDouble?
    
    private var value: EvaluatedInDouble = 0 {
        didSet { delegate?.getUrgentEvaluatedValue(value) }
    }
    
    // MARK: - `Operand` 를 컨트롤러로부터 전달 받았을 때, 이를 처리함.
    func receiveOperand(_ operand: OperandString) {
        if isEvaluating {
            if isEqualWithLastEvaluated(operand) {
                buildingExpression.add(element: makeToken(operand))
            } else {
                clearRecordedExpression()
                addOperand(makeToken(operand))
            }
        } else {
            addOperand(makeToken(operand))
        }
    }
    // MARK: - `Operator` 를 컨트롤러로부터 전달 받았을 때, 이를 처리함.
    func receiveOperator(_ _operator: OperatorString) {
        let newtoken = makeToken(_operator)
        let oldtoken = mostRecentOperatorToken
        
        if isEvaluating { stopContinuingEvaluation() }
        if mostRecentTokenIsOperator() {
            replaceOperator(with: newtoken); return
        } else if needBreakingExpression(with: newtoken) {
            breakExpression()
        }
        addOperator(makeToken(_operator))
        
        if let first = oldtoken?.extractOperator, let second = newtoken.extractOperator {
            if second.isHigher(than: first) {
                completeExpression.setNeedsCloseBracket()
            }
        }
    }
    // MARK: - `Half-Operator` 를 컨트롤러로부터 전달 받았을 때, 이를 처리함.
    func receiveHalfOperator(_ halfOperator: String) {
        guard buildingExpression.count >= 1 else { return }
        let token = factory.create(halfOperator)
        if isIncompleteExpression() {
            if let extracted = token.extractHalfOperator {
                let value = extracted.calculate(number: buildingExpression.remove()!.extractOperand!)
                buildingExpression.add(element: makeToken(String(value)))
                completeExpression.add(element: token)
                self.value = value
            }
            return
        } else if isUnbalancedExpression() {
            if let extracted = token.extractHalfOperator {
                var number = mostRecentOperandToken!.extractOperand!
                number = extracted.calculate(number: number, ratio: number)
                delegate?.getUrgentReplaceableValue(number)
            }
        } else {
            if let extracted = token.extractHalfOperator {
                var number = mostRecentToken!.extractOperand!
                number = extracted.calculate(number: number)
                delegate?.getUrgentReplaceableValue(number)
                buildingExpression.remove()
            }
        }
    }
    // MARK: - 평가 명령을 받았을 때, 이를 처리함.
    func receiveEvaluation() -> EvaluatedInDouble? {
        if isEvaluating { prepareContinuingEvaluation() }
        else if isIncompleteExpression() { reset(); return nil }
        if isUnbalancedExpression() { makeBalancedExpression() }
        surroundWithBrackets()
        return performEvaluation()
    }
    // MARK: - 초기화 명령을 받았을 때, 이를 처리함.
    func receiveClear() {
        reset()
    }
    // MARK: - 표현식 명령을 받았을 때, 이를 처리함.
    func receiveExpression() -> [String] {
        return completeExpression.get().map { $0.description }
    }
}
private extension CalculatorCore {
    func performEvaluation() -> EvaluatedInDouble {
        let evaluated = evaluate()
        maintainResultInformation(with: evaluated)
        setContinuingEvaluation()
        return evaluated
    }
    func maintainResultInformation(with result: EvaluatedInDouble) {
        let information = InformationEvaluated(result,
                                               mostRecentOperatorToken!,
                                               mostRecentOperandToken!)
        history.setEvaluatedInformation(information)
        evaluatedOperator = mostRecentOperatorToken
        evaluatedOperand = mostRecentOperandToken
        mostRecentEvaluated = result
    }
    func prepareContinuingEvaluation() {
        addOperator(evaluatedOperator!)
        addOperand(evaluatedOperand!)
    }
    func isIncompleteExpression() -> Bool {
        return buildingExpression.get().count <= 1
    }
    func isEqualWithLastEvaluated(_ string: OperandString) -> Bool {
        return Double(string)!.isEqual(to: mostRecentEvaluated!)
    }
    func isNonzeroOperand(_ string: OperandString) -> Bool {
        return Double(string)!.isZero == false
    }
    func isNotMonomialExpression() -> Bool {
        return completeExpression.get().count > 1
    }
    func isUnbalancedExpression() -> Bool {
        return mostRecentToken?.extractOperand == nil
    }
    func surroundWithBrackets() {
        completeExpression.insert(Token(bracket: .Open), at: 0)
        completeExpression.add(element: Token(bracket: .Closed))
    }
    func setContinuingEvaluation() {
        isEvaluating = true
    }
    func stopContinuingEvaluation() {
        isEvaluating = false
    }
    func makeToken(_ string: String) -> Token {
        return factory.create(string)
    }
    func formExpressionAfterEvaluation(with token: Token) {
        buildingExpression.add(element: token)
        addOperator(mostRecentOperatorToken!)
        addOperand(mostRecentOperandToken!)
    }
    func removeLastToken() -> Token? {
        return buildingExpression.remove()
    }
    func addToken(_ token: Token) {
        buildingExpression.add(element: token)
        completeExpression.add(element: token)
        history.setReceivedToken(token)
        mostRecentToken = token
    }
    func addOperand(_ token: Token) {
        addToken(token)
        mostRecentOperandToken = token
    }
    func addOperator(_ token: Token) {
        if buildingExpression.count == 0 {
            let zerotoken = makeToken("0")
            addOperand(zerotoken)
            mostRecentOperandToken = zerotoken
        }
        addToken(token)
        mostRecentOperatorToken = token
    }
    func replaceOperator(with token: Token) {
        buildingExpression.remove()
        completeExpression.remove()
        addOperator(token)
    }
    func breakExpression() {
        let evaluated = evaluate()
        let token = makeToken(String(evaluated))
        buildingExpression.add(element: token)
        value = evaluated
    }
    func makeBalancedExpression() {
        addOperand(mostRecentOperandToken!)
    }
    func mostRecentTokenIsOperator() -> Bool {
        return mostRecentToken?.extractOperator != nil
    }
    func needBreakingExpression(with token: Token) -> Bool {
        guard let old = mostRecentOperatorToken else { return false }
        return checker.check(old, token)
    }
    func clearRecordedExpression() {
        buildingExpression.clear()
        completeExpression.clear()
    }
    func reset() {
        clearRecordedExpression()
        mostRecentOperandToken = nil
        mostRecentOperatorToken = nil
        mostRecentToken = nil
        evaluatedOperand = nil
        evaluatedOperator = nil
        isEvaluating = false
    }
    func evaluate() -> Double {
        let expression = buildingExpression.build()
        let converted = converter.convert(expression)
        let evaluated = evaluator.evaluate(converted)
        
        return evaluated
    }
}
