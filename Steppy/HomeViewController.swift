//
//  HomeViewController.swift
//  Steppy
//
//  Created by Cherlia Brightokta on 19/09/19.
//  Copyright © 2019 Cherlia Brightokta. All rights reserved.
//

import UIKit
import Foundation
import HealthKit

enum Preferences: String {
  case isOpenedFirstTime
  case useFaceIDOnLaunch
  case username
  case userStepsGoal
  case userIsRegistered
}


class HomeViewController: UIViewController {
  
  var isOpenedFirstTime: Bool = true
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var stepsToGoLabel: UILabel!
  @IBOutlet weak var stepsTodayLabel: UILabel!
  @IBOutlet weak var dailyTargetLabel: UILabel!
  
  @IBAction func unwindToHomeController(segue: UIStoryboardSegue) {}
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if isOpenedFirstTime {
      let vc = storyboard?.instantiateViewController(withIdentifier: "Onboarding") as! OnBoardingViewController
      isOpenedFirstTime = false
      self.present(vc, animated: true, completion: nil)
    } else {
      getTodaySteps { (steps, error) in
        DispatchQueue.main.async {
          
          let registeredUser = UserDefaults.standard.string(forKey: Preferences.username.rawValue)
          let dailyStepsGoal = UserDefaults.standard.integer(forKey: Preferences.userStepsGoal.rawValue)
          
          self.nameLabel.text = registeredUser ?? ""
          self.dailyTargetLabel.text = "\(dailyStepsGoal)"
          
          print(steps)
          
          self.stepsTodayLabel.text = "\(Int(steps))"
          let stepsToGo = dailyStepsGoal - Int(steps)
          self.stepsToGoLabel.text = "\(stepsToGo)"
        }
      }
    }
  }
  
  func getTodaySteps(completion: @escaping(Double, Error?) -> ()) {
    
    let storage = HKHealthStore()
    
    let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    
    let now = Date()
    let startOfDay = Calendar.current.startOfDay(for: now)
    
    let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
    
    let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (stats, results, error) in
      guard let results = results, let sum = results.sumQuantity() else {
        completion(0.0, nil)
        return
      }
      completion(sum.doubleValue(for: .count()), nil)
    }
    storage.execute(query)
  }
  
  
  
  @IBAction func submitButtonPressed(_ sender: Any) {
  }
  
  
}



