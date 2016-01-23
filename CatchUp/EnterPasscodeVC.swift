//
//  EnterPasscodeVC.swift
//  CatchUp
//
//  Created by Shivam Kapur on 20/01/16.
//  Copyright © 2016 Shivam Kapur. All rights reserved.
//

import UIKit
import Parse


class EnterPasscodeVC: UIViewController,UITextFieldDelegate {

    @IBOutlet var passcodeTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }

    @IBAction func takeMeToMainChannelButtonTapped(sender: AnyObject) {
        
        if let passcode = passcodeTextField.text where passcode != "" {
            let query = PFQuery(className: "Group")
            query.whereKey("CreatedBy", equalTo: PFUser.currentUser()!)
            query.orderByDescending("createdAt")
            query.getFirstObjectInBackgroundWithBlock({ (object:PFObject?,error: NSError?) -> Void in
                if error != nil {
                    print("Error \(error?.code)")
                }   else {
                    if let object = object {
                        object["Passcode"] = passcode 
                        object.saveInBackgroundWithBlock({ (success:Bool,error: NSError?) -> Void in
                            if error != nil {
                                self.createAlert("Oops", message: "An Error Occured. Please try agian later.")
                            }   else {
                                self.performSegueWithIdentifier(SEGUE_SUCCESSFULLYCREATEDGROUP, sender: nil)
                            }
                            
                        })
                    }
                }
            })
        }   else {
            createAlert("Missing Passcode", message: "Please enter a passcode to ensure the security of the group.")
        }
    }
    func createAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
