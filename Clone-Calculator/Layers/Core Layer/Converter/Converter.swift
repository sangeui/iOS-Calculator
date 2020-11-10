//
//  Converter.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/09/29.
//

import Foundation

protocol Converter {
    func convert(_ expression: [Token]) -> [Token]
}
