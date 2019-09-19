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
  
  @IBOutlet weak var registerButton: UIButton! {
    didSet {
      self.registerButton.isEnabled = false
    }
  }
  @IBOutlet weak var nameTextBox: UITextField!
  @IBOutlet weak var dailyTargetTextBox: UITextField!
  
  //Done toolbar button
  let toolbar: UIToolbar = {
    let tb = UIToolbar()
    tb.barStyle = UIBarStyle.default
    tb.items = [
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
      UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDoneTapped))
    ]
    tb.sizeToFit()
    return tb
  }()
  
  
  var bothTextFieldIsFilled = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    checkRegisterStatus()
    
    nameTextBox.delegate = self
    dailyTargetTextBox.delegate = self
    
    dailyTargetTextBox.inputAccessoryView = self.toolbar
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  @objc func handleDoneTapped() {
    self.dailyTargetTextBox.resignFirstResponder()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    evaluateBothTextField()
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
    if nameTextBox.text?.count == 0 || dailyTargetTextBox.text?.count == 0 {
      print("")
    }
  }
  
  
  func evaluateBothTextField() {
    if nameTextBox.text!.count > 0 && dailyTargetTextBox.text!.count > 0 {
      self.registerButton.isEnabled = true
    }
  }
  
  @IBAction func registerButtonPressed(_ sender: Any) {
    
    UserDefaults.standard.set(nameTextBox.text!, forKey: Preferences.username.rawValue)
    UserDefaults.standard.set(Int(dailyTargetTextBox.text!), forKey: Preferences.userStepsGoal.rawValue)
    UserDefaults.standard.set(true, forKey: Preferences.userIsRegistered.rawValue)
    
    
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
          DispatchQueue.main.async {
            self.performSegue(withIdentifier: "unwindToHomeController", sender: self)
          }
        }
      }
    } else {
      print(error?.localizedDescription)
      print("face id failed")
    }
    
    
  }
  
}

