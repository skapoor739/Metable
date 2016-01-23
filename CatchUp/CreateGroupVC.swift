//
//  CreateGroupVC.swift
//  CatchUp
//
//  Created by Shivam Kapur on 17/01/16.
//  Copyright © 2016 Shivam Kapur. All rights reserved.
//

import UIKit
import Parse

class CreateGroupVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var groupNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    
    

    @IBAction func createGroupButtonTapped(sender: AnyObject) {
        
        let query = PFQuery(className: "Group")
        query.selectKeys(["GroupName"])
        var names = [String]()
        
        let counter = 1
        var count = 0
        if let groupName = groupNameTextField.text where groupName != "" {
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?,error: NSError?) -> Void in
            if error != nil {
                print("Error \(error?.code)")
            }   else {
                if let objects = objects {
                    for object in objects {
                        let name = object["GroupName"] as! String
                        print(name)
                        names.append(name)
                    }
                    print(names)
                    for name in names {
                        if name == groupName {
                            print("Matched")
                            count++
                        }   else {
                            print("Nope")
                        }
                    }
                    
                    if count >= counter {
                        self.createAlert("Group Name already exists.", message: "The group name you are trying to use already exists.Please try again with another name.")
                        count = 0
                    }   else {
                        let group = PFObject(className: "Group")
                        group["GroupName"] = groupName
                        group.saveInBackgroundWithBlock({ (success:Bool,error: NSError?) -> Void in
                            if error != nil {
                                print("Error")
                            }   else {
                                let query = PFQuery(className: "Group")
                                query.whereKey("GroupName", equalTo:groupName)
                                query.getObjectInBackgroundWithId(group.objectId!, block: { (group:PFObject?,error: NSError?) -> Void in
                                    if error != nil {
                                        print("Error \(error?.code)")
                                    }   else {
                                        if let group = group {
                                            group["CreatedBy"] = PFUser.currentUser()
                                            group.saveInBackground()
                                            let user = PFUser.currentUser()
                                            user!["GroupName"] = groupName
                                            user!["isAccountSetUp"] = true
                                            user?.saveInBackground()
                                            self.performSegueWithIdentifier(SEGUE_CHOOSEPASSCODE, sender: nil)
                                        }
                                    }
                                    
                                })
                            }
                            
                        })
                    }
                }
            }
            
        }
        }   else {
            createAlert("Missing Field", message: "Please enter a group name!")
        }
    }
    
    func createAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
