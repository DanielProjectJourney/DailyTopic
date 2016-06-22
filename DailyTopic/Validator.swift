//
//  Validator.swift
//  DailyTopic
//
//  Created by Daniel on 24/05/2016.
//  Copyright © 2016 Daniel. All rights reserved.
//

import Foundation
import UIKit

public struct Validator {
    
    //Validator the Login Email format
    public static func isEmailValid(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailCheck = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailCheck.evaluateWithObject(email)
    }
    
    
}

