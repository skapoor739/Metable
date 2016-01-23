//
//  ConfirmPasswordVC.swift
//  CatchUp
//
//  Created by Shivam Kapur on 21/01/16.
//  Copyright © 2016 Shivam Kapur. All rights reserved.
//

import UIKit
import Parse

class ConfirmPasswordVC: UIViewController,UITextFieldDelegate {

    @IBOutlet var passcodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passcodeTextField.delegate = self
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func takeMeToMyChannelButtonTapped(sender: AnyObject) {
        if let passcode = passcodeTextField.text where passcode != "" {
            let group = PFQuery(className: "Group")
            group.orderByDescending("updatedAt")
            group.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?,error: NSError?) -> Void in
                if error != nil {
                    print("Error")
                }   else {
                    if let objects = objects {
                        for object in objects {
                            let receivedPasscode = object["Passcode"] as! String
                            if receivedPasscode == passcode {
                                let user = PFUser.currentUser()!
                                user["isAccountSetUp"] = true
                                user.saveInBackground()
                                self.performSegueWithIdentifier(SEGUE_GROUPJOINEDSUCCESSFULLY, sender: nil)
                            }   else {
                                self.createAlert("Incorrect Passcode", message: "Please enter the correct passcode and try again.")
                            }
                        }
                    }
                }
                
            })
        }   else {
            createAlert("Missing Fields.", message: "Please make sure that you have entered the passcode and try again.")
        }
    }
    
    func createAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
