//
//  MagActor.swift
//  DTest Watch App
//
//  Created by PNT001 on 1/9/24.
//

import Foundation
import CoreMotion

class MagActor: Actor {
    var manager: CMMotionManager!
    var timer: Timer!
    
    init(manager: CMMotionManager) {
        self.manager = manager
    }
    
    func action() {
                
        if manager.isMagnetometerAvailable {
            self.manager.accelerometerUpdateInterval = 1
            self.manager.startMagnetometerUpdates()
            
            self.timer = Timer(fire: Date(), interval: 1,
           repeats: true, block: { (timer) in
                if let data = self.manager.magnetometerData {
                    print("Mag : \(data.magneticField.x) \(data.magneticField.y) \(data.magneticField.z)")
                }
           
           })
            RunLoop.current.add(self.timer!, forMode: .default)
        } else {
            print("Magnetometer is not available")
        }
        
    }
}
