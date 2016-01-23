//
//  JoinOrCreateGroupVC.swift
//  CatchUp
//
//  Created by Shivam Kapur on 15/01/16.
//  Copyright © 2016 Shivam Kapur. All rights reserved.
//

import UIKit
import Parse

class JoinOrCreateGroupVC: UIViewController,UITextFieldDelegate {

    let user = PFUser.currentUser()
    
    @IBOutlet var greetUserLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let query = PFQuery(className: "_User")
        
        query.selectKeys(["FirstName"])
        
        query.getObjectInBackgroundWithId((user?.objectId)!) { (object:PFObject?,error: NSError?) -> Void in
            if error != nil {
                print("Error occured \(error?.code)")
            }   else {
                if let object = object {
                    let firstName = object["FirstName"] as? String
                    self.greetUserLabel.text = "Welcome, \((firstName)!)!"
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func createANewGroupButtonTapped(sender: AnyObject) {
        
        self.performSegueWithIdentifier(SEGUE_CREATEANEWGROUP, sender: nil)
    }
    
    @IBAction func joinAnExistingGroupButtonTapped(sender: AnyObject) {
        
        self.performSegueWithIdentifier(SEGUE_JOINANEXISTNGGROUP, sender: nil)
    }
}
