//
//  JoinGroupVS.swift
//  CatchUp
//
//  Created by Shivam Kapur on 17/01/16.
//  Copyright © 2016 Shivam Kapur. All rights reserved.
//

import UIKit
import Parse

class JoinGroupVC: UIViewController,UITextFieldDelegate {

    @IBOutlet var joinGroupTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        joinGroupTextField.delegate = self

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
        
    @IBAction func joinGroupButtonTapped(sender: AnyObject) {
        
        if let joinGroupText = joinGroupTextField.text where joinGroupText != "" {
            let query = PFQuery(className: "Group")
            query.whereKey("GroupName", equalTo: joinGroupText)
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?,error: NSError?) -> Void in
                var receivedName = ""
                var userArray = [AnyObject]()
                if error != nil {
                    self.createAlert("An Error Occured.", message: "Sorry! We are having some trouble processing your request. Please try again later.")
                }
                
                if let objects = objects {
                    for object in objects {
                        let name = object["GroupName"] as! String
                        receivedName = name
                        userArray.append(PFUser.currentUser()!)
                    }
                }
                
                if receivedName != joinGroupText {
                    self.createAlert("Group Not found.", message: "A group with a matching name was not found.")
                }   else if receivedName == joinGroupText {
                    let group = PFQuery(className: "Group")
                    group.whereKey("GroupName", equalTo: receivedName)
                    group.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?,error: NSError?) -> Void in
                        
                        let query = PFQuery(className: "Group")
                        userArray.append(PFUser.currentUser()!)
                        if error != nil {
                            self.createAlert("Error occured.", message: "Sorry! We are having truoble processing your request. Please try after sometime")
                        }   else {
                            if let objects = objects {
                                for object in objects {
                                    query.getObjectInBackgroundWithId(object.objectId!, block: { (object:PFObject?, error:NSError?) -> Void in
                                        if error != nil {
                                            print("Error Occured")
                                        }   else {
                                            if let object = object {
                                                    let user = PFUser.currentUser()!
                                                    user["GroupName"] = receivedName
                                                    user.saveInBackground()
                                                    object["Users"] = userArray
                                                    object.saveInBackground()
                                                    self.performSegueWithIdentifier(SEGUE_ENTERPASSCODE, sender: nil)
                                            }
                                        }
                                        
                                    })
                                }
                            }
                        }
                        
                    })
                }
                
                
            })
        } else {
            createAlert("Invlaid Input", message: "Please enter a group name!")
        }
        
    }
    
    func createAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
