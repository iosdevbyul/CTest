//
//  WaitingList.swift
//  CTest
//
//  Created by PNT001 on 1/24/24.
//

import Foundation

struct WaitingList {
    
    private let ud = UserDefaults.standard
    
    let key = "waitingList"
    private var stack: [URL] = [] {
        didSet {
            print("stack : ",stack)
        }
    }
    
    var count: Int {
        return stack.count
    }
    
    var isEmpty: Bool {
        return stack.isEmpty
    }
    
    mutating func push(_ new: URL) {
        stack.append(new)
    }
    
    mutating func pop() -> URL? {
        return isEmpty ? nil : stack.popLast()
    }
}
