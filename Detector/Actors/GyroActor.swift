//
//  GyroActor.swift
//  DTest Watch App
//
//  Created by PNT001 on 1/9/24.
//

import Foundation
import CoreMotion

class GyroActor: Actor {

    var manager: CMMotionManager!
    var timer: Timer!
    
    init(manager: CMMotionManager) {
        self.manager = manager
    }
    
    func action() {
        if manager.isGyroAvailable {
              
            self.manager.gyroUpdateInterval = 1
            self.manager.startGyroUpdates()

              // Configure a timer to fetch the accelerometer data.
              self.timer = Timer(fire: Date(), interval: 1,
                     repeats: true, block: { (timer) in
                 // Get the gyro data.
                 if let data = self.manager.gyroData {
                    let x = data.rotationRate.x
                    let y = data.rotationRate.y
                    let z = data.rotationRate.z


                    // Use the gyroscope data in your app.
                     print("Gyro : \(x) \(y) \(z)")
                 }
              })


              // Add the timer to the current run loop.
            RunLoop.current.add(self.timer!, forMode: .default)
        } else {
            print("Not available to use the Gyro sensor")
        }
    }
    
}
