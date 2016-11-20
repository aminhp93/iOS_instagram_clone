/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupMode = true
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    
    @IBAction func signUpButton(_ sender: Any) {
        print(signupMode)
        if emailTextField.text == "" || passwordTextField.text == "" {
            createAlert(title: "Error in form", message: "Please enter an email and password")
        } else {
            if signupMode {
                // Sign Up
                
                let user = PFUser()
                user.username = emailTextField.text
                user.email = emailTextField.text
                user.password = passwordTextField.text
                user.signUpInBackground(block: { (success, error) in
                    if error != nil {
                        self.createAlert(title: "Error in form", message: "Parse Error")
                    } else {
                        print("user sign up")
                    }
                })
            }
            
            
            
        }
        
        
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        if signupMode{
            // Change to login mode
            signUpButton.setTitle("Log In", for: [])
            loginButton.setTitle("Sign Up", for: [])
            
            messageLabel.text = "Don't have an account"
            signupMode = false
        } else {
            // Change to signup mode
            signUpButton.setTitle("Sign Up", for: [])
            loginButton.setTitle("Log In", for: [])
            messageLabel.text = "Already have an account"
            signupMode = true
        }

    }
    
    
    
}
