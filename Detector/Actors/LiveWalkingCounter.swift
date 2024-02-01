//
//  LiveWalkingCounter.swift
//  DTest Watch App
//
//  Created by PNT001 on 1/9/24.
//

import Foundation
import CoreMotion

class LiveWalkingCounter {
    let manager = CMPedometer()
    
    init() {
        print("enter")
        
        switch CMPedometer.authorizationStatus() {
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorized:
            print("authorized")
        @unknown default:
            print("default")
        }
        
        if CMPedometer.isStepCountingAvailable() && CMPedometer.isDistanceAvailable() && CMPedometer.isPedometerEventTrackingAvailable(){
            print("good to proceed")
            
            
            Timer.scheduledTimer(timeInterval: 30.0,
                                 target: self,
                                 selector: #selector(checkSteps),
                                 userInfo: nil,
                                 repeats: true)
        }
    }
    
    @objc private func checkSteps() {

        guard let todayStartDate = Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date()) else {
            return
        }
        
        manager.queryPedometerData(from: todayStartDate, to: Date()) { data, error in
            if let error {
                print("CoreMotionService.queryPedometerData Error: \(error)")
                return
            }
            
            if let steps = data?.numberOfSteps {
                DispatchQueue.main.async {
                    print("steps = \(steps)")
                }
            }
            
            if let distance = data?.distance {
                DispatchQueue.main.async {
                    print("distance = \(distance)")
                }
            }
        }
        
        
    }

}
