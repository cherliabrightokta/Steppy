//
//  HealthKitSetupAssistant.swift
//  Steppy
//
//  Created by Cherlia Brightokta on 19/09/19.
//  Copyright © 2019 Cherlia Brightokta. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitSetupHelper {
    
    enum HealthKitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    class func authorizeHealthKit(completion: @escaping(Bool, Error?) -> Void) {
        
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthKitSetupError.notAvailableOnDevice)
            return
        }
        
        guard let stepsData = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            completion(false, HealthKitSetupError.dataTypeNotAvailable)
            return
        }
        
        let healthKitTypesToRead: Set<HKObjectType> = [stepsData]
        
        HKHealthStore().requestAuthorization(toShare: nil, read: healthKitTypesToRead) { (success, error) in
            completion(success, error)
        }
    }
}
