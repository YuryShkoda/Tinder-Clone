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
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signupOrLoginButton: UIButton!
    @IBOutlet weak var changeSignupModeButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func signupOrLogin(_ sender: Any) {
        
        if signupMode {
        
            let user = PFUser()
            
            user.username = nameTextfield.text
            user.password = passwordTextfield.text
            
            let acl = PFACL()
            
            acl.getPublicWriteAccess = true
            acl.getPublicReadAccess  = true
            
            user.acl = acl
            
            user.signUpInBackground(block: { (success, error) in
                
                if error != nil {
                
                    var errorMessage = "Signup failed - please try again"
                    
                    let error = error as? NSError
                    
                    if let parseError = error?.userInfo["error"] as? String {
                    
                        errorMessage = parseError
                    
                    }
                    
                    self.errorLabel.text = errorMessage
                
                } else {
                
                    print("Signed up")
                    
                    self.performSegue(withIdentifier: "goToUserInfo", sender: self)
                
                }
                
            })
        
        } else {
        
            PFUser.logInWithUsername(inBackground: nameTextfield.text!, password: passwordTextfield.text!, block: { (user, error) in
                
                if error != nil {
                
                    var errorMessage = "Signup failed - please try again"
                    
                    let error = error as? NSError
                    
                    if let parseError = error?.userInfo["error"] as? String {
                        
                        errorMessage = parseError
                        
                    }
                    
                    self.errorLabel.text = errorMessage
                
                } else {
                
                    print("Logged in")
                    
                    self.redirectUser()
                
                }
                
            })
        
        }
        
    }
    
    @IBAction func changeSignupMode(_ sender: Any) {
        
        if signupMode {
            
            signupMode = false
            
            signupOrLoginButton.setTitle("Log In", for: [])
            
            changeSignupModeButton.setTitle("Sign Up", for: [])
        
        } else {
        
            signupMode = true
            
            signupOrLoginButton.setTitle("Sign Up", for: [])
            
            changeSignupModeButton.setTitle("Log In", for: [])
            
        }
        
    }
    
    func redirectUser() {
        
        if PFUser.current()?["isFemale"] != nil && PFUser.current()?["isInterestedInWomen"] != nil && PFUser.current()?["photo"] != nil {
        
            performSegue(withIdentifier: "swipeFromInitialSegue", sender: self)
        
        } else {
        
            performSegue(withIdentifier: "goToUserInfo", sender: self)
        
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current()?.objectId != nil {
            
            redirectUser()
        
        } else {
        
            print("New user")
        
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
