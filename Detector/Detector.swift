//
//  Detector.swift
//  DTest Watch App
//
//  Created by PNT001 on 1/9/24.
//

import Foundation
import CoreMotion

class Detector { //centre access point to all detections
    init() {
        startCM()
//        startCL()
    }
    
    private func startCM() {
        let manager = CMMotionManager()
        
        if manager.isDeviceMotionAvailable {
     
            print("manager.isGyroAvailable",manager.isGyroAvailable)
            print("manager.isAccelerometerAvailable",manager.isAccelerometerAvailable)
            print("manager.isMagnetometerAvailable",manager.isMagnetometerAvailable)

            manager.startGyroUpdates()
            if manager.isGyroAvailable {
                print("Gyro's available")
                let gyroActor = GyroActor(manager: manager)
                gyroActor.action()
            } else {
                print("Gyro's not available")
                let attActor = AttActor(manager: manager)
                attActor.action()
            }
            
            let accActor = AccActor(manager: manager)
            accActor.action()
            let magActor = MagActor(manager: manager)
            magActor.action()
        }
    }
    
    private func startCL() {
        
        let location = Helicopter()
    }
}
