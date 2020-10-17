//
//  ViewController.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/09/22.
//

// Reqeust -> Send

import UIKit

class BaseController: UIViewController {
    
    @IBOutlet weak var mainDisplay: UILabel!
    @IBOutlet weak var subDisplay: SubDisplayView!
    @IBOutlet weak var clearButton: CalculatorButton!

    private let core = CalculatorCore()
    private var director = OperandDirector(builder: Builder<String>())
    private var refinery = Refinery(9)
    private var bucket = Bucket<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ready()
    }
    
    // MARK: - `Clear` 버튼이 입력되었을 때, 이를 처리함
    @IBAction func actionForClearButton(_ sender: UIButton) {
        handleClear()
    }
    // MARK: - `+/-` 버튼이 입력되었을 때, 이를 처리함
    @IBAction func actionForSignButton(_ sender: UIButton) {
        handleSign()
    }
    // MARK: - `.` 버튼이 입력되었을 때, 이를 처리함
    @IBAction func actionForDecimalPointButton(_ sender: UIButton) {
        handleDecimalPoint()
    }
    // MARK: - 피연산자 버튼이 입력되었을 때, 이를 처리함
    @IBAction func actionForNumberButton(_ sender: UIButton) {
        let calculatorButton = sender as! CalculatorButton
        handleNumber(calculatorButton.getButtonValue())
    }
    // MARK: - 연산자 버튼이 입력되었을 때, 이를 처리함
    @IBAction func actionForOperatorButton(_ sender: UIButton) {
        let calculatorButton = sender as! CalculatorButton
        handleOperator(calculatorButton.getButtonValue())
    }
    // MARK: -
    @IBAction func actionForHalfOperatorButton(_ sender: UIButton) {
        let calculatorButton = sender as! CalculatorButton
        handleHalfOperator(calculatorButton.getButtonValue())
    }
    // MARK: - 계산 버튼이 입력되었을 때, 이를 처리함
    @IBAction func actionForEqualButton(_ sender: UIButton) {
        handleCalculation()
    }
    // MARK: - 표현식 버튼이 입력되었을 때, 이를 처리함
    @IBAction func actionForShowButton(_ sender: UIButton) {
        handleShowingExpression()
    }
}
extension BaseController {
    
}
private extension BaseController {
    func handleShowingExpression() {
        updateExpressionView(makeEnteredExpression())
    }
    func handleCalculation() {
        sendProperOperandBefore()
        if let calculatedResult = sendCalculation() {
            updateBasedResult(with: calculatedResult)
        } else { handleFailureofCalculation() }
    }
    func handleHalfOperator(_ symbol: String) {
        sendProperOperandBefore()
        sendHalfOperator(symbol)
    }
    func handleOperator(_ symbol: String) {
        sendProperOperandBefore()
        sendOperator(symbol)
    }
    func handleNumber(_ number: String) {
        pourBucketIfNeeded()
        director.receiveNumber(number)
        updateOperationView()
        makeClearButtonPossible()
    }
    func handleDecimalPoint() {
        pourBucketIfNeeded()
        director.receiveDeciamlSeparator()
        updateOperationView()
    }
    func handleSign() {
        if let poured = pourBucketIfNeeded() {
            let converted = poured.isNegativeNumberString() ? String(poured.dropFirst()) : "-\(poured)"
            fillBucket(with: Double(converted)!)
            updateOperationView(makeExpressibleNumber(Double(converted)!))
        } else {
            handleMinusSign()
            updateOperationView()
        }
    }
    func handleClear() {
        isCurrentlyEnteredOperand() ?
            shallowClear() : deepClear()
    }
    func shallowClear() {
        director.receiveClear()
        updateOperationView()
        makeAllClearButtonPossible()
    }
    func deepClear() {
        director.receiveClear()
        pourBucketIfNeeded()
        sendClear()
        updateExpressionView("")
    }
}
// MARK: - 단독으로 `Core` 메소드를 호출하는 Extension
private extension BaseController {
    func sendHalfOperator(_ halfOperator: String) {
        core.receiveHalfOperator(halfOperator)
    }
    func sendOperand(_ operand: String) {
        core.receiveOperand(operand)
    }
    func sendOperator(_ _operator: String) {
        core.receiveOperator(_operator)
    }
    func sendClear() {
        core.receiveClear()
    }
    func sendCalculation() -> EvaluatedDouble? {
        return core.receiveEvaluation()
    }
}
// MARK: - 단독으로 `Director` 메소드를 호출하는 Extension
private extension BaseController {
    func handleMinusSign() {
        director.receiveMinusSign()
    }
    func requestOperand() -> OperandString {
        return director.receiveBuildingOperand()
    }
}
// MARK: - 단독으로 그 이외 객체들의 메소드를 호출하는 Extension
private extension BaseController {
    func makeExpressibleNumber(_ number: Double) -> String {
        return refinery.refine(number)
    }
    @discardableResult
    func pourBucketIfNeeded() -> String? {
        return bucket.pour()
    }
    func fillBucket(with number: Double) {
        bucket.fill(String(number))
    }
}
// MARK: - `View` 를 업데이트 하는 메소드 묶음
private extension BaseController {
    func updateExpressionView(_ expression: String) {
        subDisplay.message(expression)
    }
    func updateBasedResult(with result: EvaluatedDouble) {
        let expressibleNumber = makeExpressibleNumber(result)
        fillBucket(with: result)
        updateOperationView(expressibleNumber)
        updateExpressionView(makeEnteredExpression())
    }
}
private extension BaseController {
    func isCurrentlyEnteredOperand() -> Bool {
        clearButton.getButtonValue() == "C"
    }
    func handleFailureofCalculation() {
        mainDisplay.shake()
        director.receiveClear()
        updateOperationView()
    }
    func sendProperOperandBefore() {
        if let poured = pourBucketIfNeeded() { sendOperand(poured)
        } else {
            let operand = requestOperand()
            if operand.isEmpty == false { sendOperand(operand) }
        }
    }
    func makeEnteredExpression() -> String {
        var expression: String = ""
        core.receiveExpression().forEach {
            if let double = Double($0) { expression.append("\(double.clean) ") }
            else { expression.append("\($0) ") }
        }
        return expression
    }
    func prepareOperandForView() -> String {
        var entered = director.receiveBorrowingOperand()
        if !entered.lastCharacter(is: ".") { entered.append(".") }
        return entered
    }
    func makeClearButtonPossible() {
        clearButton.setButtonValue("C")
    }
    func makeAllClearButtonPossible() {
        clearButton.setButtonValue("AC")
    }
    func updateOperationView(_ string: String? = nil) {
        if let newValue = string {
            mainDisplay.text = newValue
        } else {
            let peaked = director.receiveBorrowingOperand()
            mainDisplay.text = refinery.convert(peaked)
            if let lastOfPeaked = peaked.last, lastOfPeaked == "." {
                mainDisplay.text?.append(".")
            }
        }
    }
    func ready() {
        core.delegate = self
        director.receiveClear()
        updateOperationView()
    }
}
extension BaseController: CalculatorCoreDelegate {
    func getUrgentEvaluatedValue(_ value: EvaluatedDouble) {
        let expressibleNumber = makeExpressibleNumber(value)
        updateOperationView(expressibleNumber)
        updateExpressionView(makeEnteredExpression())
    }
    func getUrgentReplaceableValue(_ value: Double) {
        let expressibleNumber = makeExpressibleNumber(value)
        updateOperationView(expressibleNumber)
        fillBucket(with: value)
    }
}
