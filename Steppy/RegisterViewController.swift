//
//  ViewController.swift
//  Steppy
//
//  Created by Cherlia Brightokta on 19/09/19.
//  Copyright © 2019 Cherlia Brightokta. All rights reserved.
//

import UIKit
import LocalAuthentication

class RegisterViewController: UIViewController, UITextFieldDelegate {

     var isRegistered = false
    
    var context = LAContext()
    
        enum AuthenticationState {
            case loggedin, loggedout
        }
    
        var state = AuthenticationState.loggedout
    
    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var dailyTargetTextBox: UITextField!
    
   
    var bothTextFieldIsFilled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
         checkRegisterStatus()
        nameTextBox.delegate = self
        dailyTargetTextBox.delegate = self
            }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        evaluateBothTextField()
    }
  
    

    func checkRegisterStatus() {
        if isRegistered == true {
            print("already registered...")
            self.dismiss(animated: true, completion: nil)
        } else {
            registerNow()
            print("haven't registered")
            
        }
        
    }
    
    func registerNow() {
        
    }
    
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
                //FaceID auth
                context = LAContext()
                context.localizedCancelTitle = "Enter username and password"
        
                var error: NSError?
        
                if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                    let reason = "Log in to your account"
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (result, error) in
                        if result {
                            print(result)
                            print("face id succeed")
                            self.dismiss(animated: true, completion: nil)
        
                        }
                    }
                } else {
                    print(error?.localizedDescription)
                    print("face id failed")
                }

        
    }
    
}

