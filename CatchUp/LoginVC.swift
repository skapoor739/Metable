//
//  LoginVC.swift
//  CatchUp
//
//  Created by Shivam Kapur on 10/01/16.
//  Copyright © 2016 Shivam Kapur. All rights reserved.
//

import UIKit
import Parse

class LoginVC: UIViewController,UITextFieldDelegate {
    
    //MARK: Outlets for text fields.
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: Let the textFields know that they have to follow the rules set forth by the UITextFieldDelegate.
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //MARK:Function: Hides the keyboard when a tap is recognized anywhere in the view.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    
    //MARK:Hide the keyboard when the return key is tapped.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    //MARK:Perform a sign in, if at all the user exists.
    @IBAction func signInButtonTapped(sender: UIButton!) {
        if let email = emailTextField.text where email != "",let password = passwordTextField.text where password != "" {
            PFUser.logInWithUsernameInBackground(email, password: password, block: { (user: PFUser?,error: NSError?) -> Void in
                if error != nil {
                    if error?.code == 205 {
                        self.createAlert("User not found", message: "The user with the specified email was not found.")
                    }
                    if error?.code == 101 {
                        self.createAlert("Incorrect Login Details.", message: "The username and/or passweord entered by you is incorrect. Please try again.")
                    }
                }   else {
                    if user?["emailVerified"] as? Bool == false {
                        self.createAlert("Email Not Verified.", message: "Please verify the email and try again.")
                    }
                    if user?["isAccountSetUp"] as? Bool == false {
                        self.performSegueWithIdentifier(SEGUE_LOGGEDIN, sender: nil)
                       
                    }
                    if user?["isAccountSetUp"] as? Bool == true {
                        self.performSegueWithIdentifier(SEGUE_ALREADYLOGGEDIN, sender: nil)
                    }
                }
            })
        }   else {
            self.createAlert("Missing Fields", message: "Make sure that you have entered all the fields and try again.")
        }
    }
    
    //MARK:Hop back to the previous view.
    @IBAction func backButtonTapped(sender: UIButton!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == SEGUE_LOGGEDIN {
                
        }
    }
    //MARK:Function for displaying an alert.
    func createAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK:Function for clearing all the text fields.
    func clearTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
        
    }
}
