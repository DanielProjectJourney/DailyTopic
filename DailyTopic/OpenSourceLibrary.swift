//
//  OpenSourceLibrary.swift
//  DailyTopic
//
//  Created by Daniel on 5/06/2016.
//  Copyright © 2016 Daniel. All rights reserved.
//

import Foundation

class OpenSourceLibrary:NSObject{
    
    var name: String?
    var licence: String?
    var url: String?
    
    init(newName:String,newLicence:String,newUrl:String)
    {
        name = newName
        licence = newLicence
        url = newUrl
    }
    
}
