//
//  BaseService.swift
//  DailyTopic
//
//  Created by Daniel on 30/04/2016.
//  Copyright © 2016 Daniel. All rights reserved.
//

import Foundation
/**
 Firebase: Online Database
 https://www.firebase.com/
 **/
import Firebase

//Set the Daniel's Firebase URL
let BASE_URL = "https://dailytopic-daniel.firebaseio.com"
let FIREBASE_REF = Firebase(url: BASE_URL)

//Get the current user by Firebase
var CURRENT_USER: Firebase
{
    let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
    
    let currentUser = Firebase(url: "\(FIREBASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
    
    return currentUser!
}
