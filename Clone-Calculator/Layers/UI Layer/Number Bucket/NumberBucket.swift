//
//  Bucket.swift
//  Clone-Calculator
//
//  Created by 서상의 on 2020/10/15.
//

// Element를 임시로 저장하는 양동이

class NumberBucket<Element> {
    private var bucket: Element?
    
    var isEmpty: Bool { bucket == nil }
    var isFilled: Bool { bucket != nil }
    
    func fill(_ element: Element) {
        self.bucket = element
    }
    func pour() -> Element? {
        defer { bucket = nil }
        return bucket
    }
    func peak() -> Element? {
        return bucket
    }
}
