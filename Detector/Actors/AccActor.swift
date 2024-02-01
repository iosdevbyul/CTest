//
//  AccActor.swift
//  DTest Watch App
//
//  Created by PNT001 on 1/9/24.
//

import Foundation
import CoreMotion

class AccActor: Actor {
    var manager: CMMotionManager!
    var timer: Timer!
    
    init(manager: CMMotionManager) {
        self.manager = manager
    }
    
    func action() {
        if self.manager.isAccelerometerAvailable {
              self.manager.accelerometerUpdateInterval = 1
              self.manager.startAccelerometerUpdates()


              // Configure a timer to fetch the data.
              self.timer = Timer(fire: Date(), interval: 1,
                    repeats: true, block: { (timer) in
                 // Get the accelerometer data.
                 if let data = self.manager.accelerometerData {
                    let x = data.acceleration.x
                    let y = data.acceleration.y
                    let z = data.acceleration.z

                    // Use the accelerometer data in your app.
                     print("Acc : \(x) \(y) \(z)")
                 }
              })


              // Add the timer to the current run loop.
              RunLoop.current.add(self.timer!, forMode: .default)
           }
    }
}
