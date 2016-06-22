//
//  TopicCategory.swift
//  DailyTopic
//
//  Created by Daniel on 21/05/2016.
//  Copyright © 2016 Daniel. All rights reserved.
//

import Foundation
import UIKit

class TopicCategory:NSObject{
    
    var title:String?
    var picture:UIImage?
    
    init(newTitle:String,newPicture:UIImage)
    {
        title = newTitle
        picture = newPicture
        
    }
    
}


