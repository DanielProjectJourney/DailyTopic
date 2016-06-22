//
//  CreateAccountViewController.swift
//  DailyTopic
//
//  Created by Daniel on 30/04/2016.
//  Copyright © 2016 Daniel. All rights reserved.
//

import UIKit
/**
 Firebase: Online Database
 https://www.firebase.com/
 **/
import Firebase

class CreateAccountViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var CreateAccount: UIButton!
    
    @IBOutlet weak var Cancel: UIButton!
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    @IBAction func CancelActionButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.layer.cornerRadius = 5
        passwordField.layer.cornerRadius = 5
        CreateAccount.layer.cornerRadius = 5
        Cancel.layer.cornerRadius = 5
        
        emailTextField.delegate = self
        passwordField.delegate = self
        
        
    }
    /**
       Creat Account by Email && User Name && Password
    **/
    @IBAction func createAccountAction(sender: AnyObject) {
        
         let userName = self.userNameTextField.text
        let email = self.emailTextField.text
        let  password = self.passwordField.text
        
        if email != "" && password != "" && userName != ""
        {
            FIREBASE_REF.createUser(email,password: password,withValueCompletionBlock: {(error,result) -> Void in
            
                if error == nil
                {
                    FIREBASE_REF.authUser(email,password:password,withCompletionBlock: {(error, authData) -> Void in
                        
                        if error == nil
                        {
                            NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                            print("Account Created :)")
                            
                            //Save the User Name and Password into the Friebase
                            let ref = Firebase(url: "https://dailytopic-daniel.firebaseio.com/DailyTopic/Users")
                        
                            let userInformation = ["UserName": userName!,"UserEmail": email!, "UserPassword": password!]
                            
                            //Save the User unique id
                            ref.childByAppendingPath(authData.uid).setValue(userInformation)
                            
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }else
                        {
                            print(error)
                        }
                        
                    })
                }else
                {
                    print(error)
                }
            
            })
        }else{
            let alert = UIAlertController(title:"Error",message:"Enter Email and Password",preferredStyle: .Alert)
            
            let action = UIAlertAction(title:"OK",style: .Default,handler:nil)
            
            alert.addAction(action)
            
            self.presentViewController(alert,animated:true,completion: nil)
        }
    }
    
    
    //Cacenl Creating account action
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField!) {    //delegate method
        
    }
    
    func textFieldShouldEndEditing(textField: UITextField!) -> Bool {  //delegate method
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
   
    
}
