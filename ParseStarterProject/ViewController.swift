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
    
    var activityIndicator = UIActivityIndicatorView()
    
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
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            activityIndicator.startAnimating()
            view.addSubview(activityIndicator)
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            
            if signupMode {
                // Sign Up
                
                let user = PFUser()
                user.username = emailTextField.text
                user.email = emailTextField.text
                user.password = passwordTextField.text
                user.signUpInBackground(block: { (success, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if error != nil {
                        print(error)
                        
                        var displayErrorMessage = "Please try again later"
                        
                        self.createAlert(title: "Error in form", message: displayErrorMessage)
                    } else {
                        print("user sign up")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                })
            } else {
                // Log In
                
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil{
                        var displayErrorMessage = "Please try again later"
                        
                        self.createAlert(title: "Error in form", message: displayErrorMessage)

                    } else {
                        print("Log In")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)

                    }
                })
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current()?.objectId != nil {
            performSegue(withIdentifier: "showUserTable", sender: self)
        }
        
        self.navigationController?.navigationBar.isHidden = true
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
