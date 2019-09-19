//
//  OnBoardingViewController.swift
//  Steppy
//
//  Created by Cherlia Brightokta on 19/09/19.
//  Copyright © 2019 Cherlia Brightokta. All rights reserved.
//

import UIKit
import Foundation
import HealthKit

class OnBoardingViewController: UIViewController {
    
  

    var healthKitIsAuthorized = false
    var isRegistered: Bool = false
//
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func authorizeButtonPressed(_ sender: Any) {
        print("checking...")
        self.checkAuthorizationStatus()
        
       
      
        
    }
    
    func checkAuthorizationStatus() {
        if healthKitIsAuthorized == true {
            print("health kit is authorized...")
//            self.dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "showRegisterSegue", sender: nil)
//            present(LeaderboardViewController(), animated: true, completion: nil)
            
        } else {
            authorizeHealthKit()
            print("health kit is not authorized...")
        }
        
    }

    func authorizeHealthKit() {
        HealthKitSetupHelper.authorizeHealthKit { (authorized, error) in
            guard authorized else {
                let baseErrorMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseErrorMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseErrorMessage)
                }
                return
            }
            print("HealthKit succesfully authorized")
            self.healthKitIsAuthorized = true
            self.checkAuthorizationStatus()
//            self.performSegue(withIdentifier: "homeSegue", sender: Any?.self)
            
        }
        
        

    }
    
    
}

