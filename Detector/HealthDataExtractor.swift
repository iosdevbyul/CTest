//
//  HealthDataExtractor.swift
//  CTest
//
//  Created by PNT001 on 1/23/24.
//

import Foundation
import HealthKit

actor HealthDataExtractor {
    
    private var healthStore: HKHealthStore?
    private var latestFetched: Double = Date().timeIntervalSince1970 - 300 {
        didSet {
            print("latestFetched updated : ",oldValue)
        }
    }
    private let fp = FileProcessor()
    
    private var dataForm = DataForm(userId: "HappyHappy", device: Device(hardware: "", software: ""), distance: [], steps: [], heartRateVariabilitySDNN: [], heartRate: [])

    private let HKQuantityTypeIdentifierTitles:[HKQuantityTypeIdentifier : HKUnit?] = [
        .stepCount : .count(),
        .distanceWalkingRunning : .meter(),
        .vo2Max: HKUnit.literUnit(with: .milli).unitDivided(by: HKUnit.gramUnit(with: .kilo).unitMultiplied(by: .minute())),
        .heartRate : HKUnit(from: "count/s"),
        .heartRateVariabilitySDNN : .secondUnit(with: .milli),
        .bodyTemperature: nil,
        .oxygenSaturation : HKUnit(from: "%")
        ]
    
    private let HKCategoryTypeIdentifierTitles: [HKCategoryTypeIdentifier] = [
        .sleepAnalysis,
        ]
    
    init() {
        Task {
            await checkHealthDataAvailability()
        }
    }
    
    private func checkHealthDataAvailability() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
            managePermission()
        } else {
            //like iPad ...
            print("not supported device tho...")
        }
    }
    
    private func managePermission() { //Only what you need. When you need it
        guard let hs = healthStore else {
            return
        }
        
        var allTypes = Set<HKObjectType>()
        for element in HKQuantityTypeIdentifierTitles {
            allTypes.insert(HKObjectType.quantityType(forIdentifier: element.key)!)
        }
        
        for element in HKCategoryTypeIdentifierTitles {
            allTypes.insert(HKObjectType.categoryType(forIdentifier: element)!)
        }
        
        hs.requestAuthorization(toShare: nil, read: allTypes) { success, error in
            if success {
                print("success")
            } else {
                if error != nil {
                    print(error ?? "")
                }
            }
        }
    }
    
    func fetchData() {
        //Time Set
        let dfPoint:Int = Int(Date().timeIntervalSince1970 - latestFetched)
        
        print("dfPoint : ",dfPoint)
        let startPoint = Calendar.current.date(byAdding: .second, value: -dfPoint, to: Date())!
        
        print("startPoint : ",startPoint)
        print("now : ",Date())
        let endPoint = Date()
        
        for qti in HKQuantityTypeIdentifierTitles {
            fetchGeneralData(qti.key, startPoint, endPoint)
        }

//        fetchSleepInfo(startPoint)
    }
    
    func fetchGeneralData(_ input: HKQuantityTypeIdentifier, _ startPoint: Date, _ endPoint: Date) {
        guard let healthStore = healthStore else {
            return
        }
        
        guard let sampleType = HKSampleType.quantityType(forIdentifier: input) else {
            fatalError("*** This method should never fail ***")
        }
        
        //Predicate 1
        let watchPredicate = HKQuery.predicateForObjects(withDeviceProperty: HKDevicePropertyKeyModel, allowedValues: ["Watch"])

        let periodPredicate = HKQuery.predicateForSamples(withStart: startPoint, end: endPoint, options: [.strictStartDate, .strictEndDate])

        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        let compoundedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:
                                                [watchPredicate, periodPredicate])
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: compoundedPredicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: sortDescriptors) { [self]
            query, results, error in
            
            guard let samples = results as? [HKQuantitySample] else {
                debugPrint(error?.localizedDescription as Any)
                return
            }
            refineData(samples, input)
        }
        healthStore.execute(query)
    }
    
    func fetchSleepInfo(_ startPoint: Date) {
        guard let healthStore = healthStore else {
            return
        }
        
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
                    
            let periodPredicate = HKQuery.predicateForSamples(withStart: Date()-86400, end: Date(), options: [])
            
            let query = HKSampleQuery(sampleType: sleepType, predicate: periodPredicate, limit: 30, sortDescriptors: []) { (query, tmpResult, error) -> Void in
                
                if error != nil {
                    return
                }
                
                if let result = tmpResult {
                    for item in result {
                        if let sample = item as? HKCategorySample {
                            print("Healthkit sleep: \(self.localizedRepresentation(sample.startDate, format: "yyyy-MM-dd HH:mm:ss")) \(self.localizedRepresentation(sample.endDate, format: "yyyy-MM-dd HH:mm:ss")) - value: \(self.getSleepType(sample.value))")
                        }
                    }
                }
            }
            
            healthStore.execute(query)
        }
    }
    
    private func refineData(_ samples: [HKQuantitySample], _ input: HKQuantityTypeIdentifier) {
        if samples.count > 0 {
            
            for sample in samples {
                let hw = sample.device?.hardwareVersion ?? "Fail to read H/W ver"
                dataForm.device = Device(hardware: hw.type, software: sample.device?.softwareVersion ?? "Fail to read S/W ver")

                let startDate = "\(sample.startDate)"//self.localizedRepresentation(sample.startDate, format: "yyyy-MM-dd HH:mm:ss")
                let endDate = "\(sample.endDate)"//self.localizedRepresentation(sample.endDate, format: "yyyy-MM-dd HH:mm:ss")
                
                if input == .stepCount {
                    dataForm.steps.append(AmassData(quantity: sample.quantity.doubleValue(for: .count()), startDate: startDate, endDate: endDate))
                } else if input == .distanceWalkingRunning {
                    dataForm.distance.append(AmassData(quantity: sample.quantity.doubleValue(for: .meter()), startDate: startDate, endDate: endDate))
                } else if input == .heartRate {
                    dataForm.heartRate.append(AmassData(quantity: sample.quantity.doubleValue(for: HKUnit(from: "count/s")), startDate: startDate, endDate: endDate))
                } else if input == .heartRateVariabilitySDNN {
                    dataForm.heartRateVariabilitySDNN.append(AmassData(quantity: sample.quantity.doubleValue(for: .secondUnit(with: .milli)), startDate: startDate, endDate: endDate))
                } else {
                    print("## Out of category")
                }
            }
        }
        
        if input == .oxygenSaturation {
            print("DataForm : ",dataForm)
            //completed
            let total = dataForm.steps.count + dataForm.distance.count + dataForm.heartRate.count + dataForm.heartRateVariabilitySDNN.count
            if total != 0 {
                latestFetched = Date().timeIntervalSince1970
            }
            Task {
                await fp.prepareFile(dataForm)
                //reset dataform
                dataForm.device.hardware.removeAll()
                dataForm.device.software.removeAll()
                dataForm.distance.removeAll()
                dataForm.steps.removeAll()
                dataForm.heartRateVariabilitySDNN.removeAll()
                dataForm.heartRate.removeAll()
            }
        }
    }
    
    private func localizedRepresentation(_ date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    private func getSleepType(_ rawValue: Int) -> String {
        if rawValue == 0 {
            return "inBed"
        } else if rawValue == 1 {
            return "asleepUnspecified"
        } else if rawValue == 2 {
            return "awake"
        } else if rawValue == 3 {
            return "asleepCore"
        } else if rawValue == 4 {
            return "asleepDeep"
        } else if rawValue == 5 {
            return "asleepREM"
        } else {
            return "fail to trans"
        }
    }
}
