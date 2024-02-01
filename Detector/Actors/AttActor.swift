//
//  AttActor.swift
//  DTest Watch App
//
//  Created by PNT001 on 1/9/24.
//

import Foundation
import CoreMotion

class AttActor: Actor {
    var manager: CMMotionManager!
    var timer: Timer!
    
    init(manager: CMMotionManager) {
        self.manager = manager
    }
    
    func action() {
        self.manager.deviceMotionUpdateInterval = 1
        self.manager.showsDeviceMovementDisplay = true
        self.manager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
        
        // Configure a timer to fetch the motion data.
        self.timer = Timer(fire: Date(), interval: 1, repeats: true,
                           block: { (timer) in
                            if let data = self.manager.deviceMotion {
                                print(data.attitude.rotationMatrix)
                                // Get the attitude relative to the magnetic north reference frame.
                                let x = data.attitude.pitch
                                let y = data.attitude.roll
                                let z = data.attitude.yaw
                                
                                let test = data.attitude.quaternion
                                // Use the motion data in your app.
                                print("Att : \(x) \(y) \(z)")
                                print(test)
                            }
        })
        
        // Add the timer to the current run loop.
        RunLoop.current.add(self.timer!, forMode: .default)
    }
}
