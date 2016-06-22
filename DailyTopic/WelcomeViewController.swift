//
//  WelcomeViewController.swift
//  DailyTopic
//
//  Created by Daniel on 3/05/2016.
//  Copyright © 2016 Daniel. All rights reserved.
//

import UIKit
/**
 Firebase: Online Database
 https://www.firebase.com/
 **/
import Firebase

class WelcomeViewController: VideoSplashViewController {

    @IBOutlet weak var LogInButton: UIButton!
    
    @IBOutlet weak var CreateAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewBackground()
        
        //Change the Button UI
        LogInButton.layer.cornerRadius = 5
        CreateAccountButton.layer.cornerRadius = 5
        
        //Identify the user from the Firebase
          if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && CURRENT_USER.authData != nil
          {
            print("You are the User")
            print(CURRENT_USER.authData.description)
            
            NSTimer.scheduledTimerWithTimeInterval(0.0, target: self, selector: "timeToMoveOn", userInfo: nil, repeats: false)
          }
        
    }
    
    //Identify whether is laread a user in DailyTopic.
    func timeToMoveOn() {
        self.performSegueWithIdentifier("AlreadyUserSegue", sender: self)
    }
    
    
    //If the user have logined , the user can go to home page directly
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //Set the background video
    func setupViewBackground()
    {
        let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("Background", ofType: "mp4")!)
        videoFrame = view.frame
        fillMode = .Resize
        alwaysRepeat = true
        sound = false
        startTime = 0.0
        duration = 34
        alpha = 0.7
        contentURL = url
    }
    
}
