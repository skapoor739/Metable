//
//  SignUpVC.swift
//  CatchUp
//
//  Created by Shivam Kapur on 09/01/16.
//  Copyright © 2016 Shivam Kapur. All rights reserved.
//

import UIKit
import Parse
import ParseTwitterUtils
import FBSDKShareKit
import FBSDKCoreKit
import FBSDKLoginKit

class SignUpVC: UIViewController,UITextFieldDelegate {

    
    //MARK:Outlets for the text fields.
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var reEnterPasswordTextField: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Let the textFields know that they have to follow the rules set forth by the UITextFieldDelegate.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        reEnterPasswordTextField.delegate = self
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
    
    //MARK:Hop back to the previous view.
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    //MARK:Perform a sign up, if at all the user enters the coorect information.
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        //MARK:Make sure that the user has indeed entered information in the text fields.
        if let email = emailTextField.text where email != "",let password = passwordTextField.text where password != "", let reEnterPassword = reEnterPasswordTextField.text where reEnterPassword != "" {
            //MARK: Make sure that the password entered in both the fields match.
            if password == reEnterPassword {
                //MARK:Create a PFUser Object to store the user.
                let user = PFUser()
                user.email = email
                user.username = email
                user.password = password
                //MARK: Begin the sign in process.
                user.signUpInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                    //MARK:Check for exceptions.
                    if error != nil {
                        //MARK:Error code 203: Email already used.
                        //MARK:Error code 202:Username/Email already used.
                        if error?.code == 203 || error?.code == 202 {
                            self.createAlert("Email taken.", message: "Looks like the user with E-Mail \(email) already has an account. Try logging in?")
                            self.clearTextFields()
                        }
                    }   else {
                        //MARK:If no errors exist then sign up the user and give him an alert to verify his email. Also,make sure that the user goes back to the main menu so that he can login.
                        self.clearTextFields()
                        self.createAlert("Account Created.", message: "You've successfullt created an account. An email containing a verification link has been sent to \(email). Click on the link and verify your E-mail.")
                       user.setObject(false, forKey: "isAccountSetUp")
                       user.saveInBackground()
                    }
                })
            }
            //MARK:If passwords do not match,then alert the user and clear the password text fields.
            else {
                clearPasswordFields()
                createAlert("Passwords do not match.", message: "Make sure that the passwords entered by you match and try again.")
            }
            
        }
            //MARK:If the user fails to enter information correctly.
        else {
            createAlert("Missing Fields", message: "Make sure that you've entered the field(s) properly and try again.")
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
        reEnterPasswordTextField.text = ""
    }
    
    //MARK:Function to clear password TextFields.
    func clearPasswordFields() {
        reEnterPasswordTextField.text = ""
        passwordTextField.text = ""
    }
}
