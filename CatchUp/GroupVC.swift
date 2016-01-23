//
//  GroupVC.swift
//  CatchUp
//
//  Created by Shivam Kapur on 10/01/16.
//  Copyright © 2016 Shivam Kapur. All rights reserved.
//

//
//    func returnUser() {
//
//        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name, email"])
//        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
//            if error != nil {
//
//            }   else {
//                let userName: String = result.valueForKey("name") as! String
//                let Email: String = result.valueForKey("email") as! String
//                print(userName)
//                print(Email)
//                self.user?.email = Email
//                self.user?.saveInBackground()
//                self.welcomeLabel.text = "\((self.user?.email)!)"
//
//            }
//        })
//    }
import UIKit
import Parse
import ParseFacebookUtilsV4
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit


class GroupVC: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var profileImage:UIImageView!
    @IBOutlet weak var firstNameTextField:UITextField!
    @IBOutlet weak var lastNameTextField:UITextField!
    @IBOutlet weak var selectImageButton:UIButton!
    @IBOutlet weak var nextButton:UIBarButtonItem!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var imagePicker = UIImagePickerController()
    
    var user = PFUser.currentUser()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidden = true
        print(user?.username!)
        
        roundImage()
        
        imagePicker.delegate = self
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImage.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    
    func clearButtonText() {
        selectImageButton.setTitle("", forState: UIControlState.Normal)
    }
    
    func roundImage() {
        profileImage.layer.cornerRadius = profileImage.frame.width/2
        profileImage.clipsToBounds = true
    }
    
    @IBAction func addImageButtonTapped(sender:AnyObject!) {
        
        
        clearButtonText()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func convertImageToNSData(image:UIImage) -> NSData? {
        let img = UIImagePNGRepresentation(image)
        return img
    }
    
    @IBAction func nextButtonPressed(sender:AnyObject!) {
        
        
        nextButton.enabled = false
        activityIndicator.hidden = false
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.startAnimating()
        
        if let firstName = firstNameTextField.text where firstName != "", let lastName = lastNameTextField.text where lastName != "" {
            if let image = profileImage.image {
                let imgData:NSData? = self.convertImageToNSData(image)
                let imgFile = PFFile(name: "profileImg.png", data: imgData!)
                imgFile?.saveInBackground()
                self.user?["ProfileImage"] = imgFile
            }
            self.user?["FirstName"] = firstName
            self.user?["LastName"] = lastName
            user?.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error != nil {
                    self.createAlert("Oops. An error occured.", message: "Looks like we are having trouble connecting to the database. Please try again")
                    self.nextButton.enabled = true
                }
                else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    self.nextButton.enabled = true
                    self.performSegueWithIdentifier(SEGUE_SETUPPHASE1, sender: nil)
                }
            })
            
        }   else {
            createAlert("Incomplete Data", message: "Please make sure that you have atleast mentioned your first and last name and try again.")
            self.nextButton.enabled = true
        }
    }
    
    //MARK:Function for displaying an alert.
    func createAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
