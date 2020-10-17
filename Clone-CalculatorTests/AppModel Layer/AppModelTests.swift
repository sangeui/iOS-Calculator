//
//  Clone_CalculatorTests.swift
//  Clone-CalculatorTests
//
//  Created by 서상의 on 2020/09/22.
//

import XCTest
@testable import Clone_Calculator

class AppModelTests: XCTestCase {
    var sut: CalculatorCore!
    
    override func setUp() {
        super.setUp()
        sut = CalculatorCore()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
