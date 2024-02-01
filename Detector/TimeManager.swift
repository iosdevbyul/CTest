//
//  TimeManager.swift
//  CTest
//
//  Created by PNT001 on 1/23/24.
//

import Foundation
import Combine

actor TimeManager {
    @Published var timeCounter = TimeCounter()
    private var cancellables = Set<AnyCancellable>()
    let extractor = HealthDataExtractor()
    
    init() {
        Task {
            await self.setup()
        }
    }
    
    private func setup() {
        setTimer()
    }
    
    private func setTimer() {
        timeCounter.$tick.sink { value in
            print(value)
            if value%300 == 0 {
                print("time to fetch")
                Task {
                    await self.extractor.fetchData()
                }
            }
        }.store(in: &cancellables)
    }
}

class TimeCounter: ObservableObject {
    @Published var tick = -1
    
    lazy var timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in self.tick += 1 }
    init() { timer.fire() }
}
