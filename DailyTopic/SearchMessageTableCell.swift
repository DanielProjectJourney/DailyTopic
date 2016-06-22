//
//  SearchMessageTableCell.swift
//  DailyTopic
//
//  Created by Daniel on 8/06/2016.
//  Copyright © 2016 Daniel. All rights reserved.
//

import UIKit

//Save Topic Delegate
protocol  SaveTopicDelegate{
    func saveTopicTapped(cell: SearchMessageTableCell)
}

class SearchMessageTableCell: UITableViewCell {

    var saveTopicDelegate: SaveTopicDelegate?

    @IBOutlet weak var searchMessageLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!

    //Save Topic Button Action
    @IBAction func saveButtonAction(sender: AnyObject) {
        
        if let delegate = saveTopicDelegate{
            delegate.saveTopicTapped(self)
        }
        
    }
    
}
