//
//  ViewController.swift
//  CatchUp
//
//  Created by Shivam Kapur on 07/01/16.
//  Copyright © 2016 Shivam Kapur. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4
import ParseTwitterUtils

@IBDesignable
class ViewController: UIViewController {

    let user = PFUser.currentUser()?.objectId
    
    var willAnimate = true
    
    //MARK: Created NSLayoutConstraint outlets for each of the buttons.
    @IBOutlet var signInButtonHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet var facebookSignInHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet var twitterSignInHorizontalConstraint: NSLayoutConstraint!
    
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var facebookButton: UIButton!
    @IBOutlet var twitterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
       override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK:Make the buttons disappear off the view.
        signInButtonHorizontalConstraint.constant += 600
        facebookSignInHorizontalConstraint.constant += 600
        twitterSignInHorizontalConstraint.constant += 600
        
        //MARK:Disable the buttons.
        signInButton.enabled = false
        facebookButton.enabled = false
        twitterButton.enabled = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        //MARK:Animate the signInButton.
        //MARK:Perform nested animations.
        if willAnimate {
        UIView.animateWithDuration(2.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 3.0, options: [.CurveLinear], animations: { () -> Void in
            self.signInButtonHorizontalConstraint.constant -= 600
            self.signInButton.layoutIfNeeded()

            }) { (completed:Bool) -> Void in
                    //MARK:Animate the facebookbutton.
                    UIView.animateWithDuration(2.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 3.0, options: [.CurveLinear], animations: { () -> Void in
                        self.facebookSignInHorizontalConstraint.constant -= 600
                        self.facebookButton.layoutIfNeeded()
                        }, completion: { (completed:Bool) -> Void in
                            
                            //MARK:Animate the twitterButton.
                            UIView.animateWithDuration(2.0, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 3.0, options: [.CurveLinear], animations: { () -> Void in
                                self.twitterSignInHorizontalConstraint.constant -= 600
                                self.twitterButton.layoutIfNeeded()
                                }, completion: { (completed:Bool) -> Void in
                                    //MARK:Once the animation completes,enable the buttons.
                                    self.signInButton.enabled = true
                                    self.facebookButton.enabled = true
                                    self.twitterButton.enabled = true
                                    self.willAnimate = false
                                    let user = PFUser.currentUser()
                                    
                                    if user != nil {
                                        self.performSegueWithIdentifier(SEGUE_ALREADYLOGGEDIN, sender: nil)
                                    }

                                })
                    })
                }
        }   else {
            self.signInButtonHorizontalConstraint.constant -= 600
            self.facebookSignInHorizontalConstraint.constant -= 600
            self.twitterSignInHorizontalConstraint.constant -= 600
            self.signInButton.enabled = true
            self.facebookButton.enabled = true
            self.twitterButton.enabled = true
            self.signInButton.layoutIfNeeded()
            self.facebookButton.layoutIfNeeded()
            self.twitterButton.layoutIfNeeded()
            
        }
    }

    @IBAction func createAccountButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier(SEGUE_SIGNUP, sender: nil)
    }
    
    //MARK:Initiate a login using Twitter.
    @IBAction func twitterLoginButtonTapped(sender: UIButton) {
        PFTwitterUtils.logInWithBlock { (user: PFUser?,error: NSError?) -> Void in
            //MARK:If any error occurs.
            if error != nil {
                self.createAlert("Unexpected Error", message: "Looks like we are having trouble trying to log you in with Twitter.Please try again.")
            }
            //MARK:If everything goes right.
            else {
                self.performSegueWithIdentifier(SEGUE_LOGGEDIN, sender: nil)
            }
            
        }
    }
    
    //MARK: Initiate a login using Facebook.
    @IBAction func facebookLoginButtonTapped(sender: UIButton) {

        PFFacebookUtils.logInInBackgroundWithReadPermissions(["email"]) { (user:PFUser?, error:NSError?) -> Void in
            //MARK:If any error occurs.
           
            if error != nil {
                self.createAlert("Unexpected Error", message: "Looks like we are having trouble trying to log you in with facebook.Please try again.")
            }
            //MARK:If everything goes right.
            else {
           
                self.performSegueWithIdentifier(SEGUE_LOGGEDIN, sender: nil)
            }
        }
        
    }
    
    @IBAction func signInButtonPressed(sender: UIButton) {
        self.performSegueWithIdentifier(SEGUE_GOTOLOGIN, sender: nil)
    }
    
    //MARK:Function for displaying an alert.
    func createAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

