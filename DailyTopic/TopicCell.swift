//
//  TopicCell.swift
//  DailyTopic
//
//  Created by Daniel on 7/05/2016.
//  Copyright © 2016 Daniel. All rights reserved.
//

import UIKit
import Firebase
import Canvas


//Follow Topic Delegate
protocol  FollowTopicDelegate{
    func followTopicTapped(cell: TopicCell)
}
//Reply Topic Delegate
protocol ReplyTopicDelegate{
    func replyButtonTapped(cell: TopicCell) -> Int
}
//Topic Message Delegate
protocol MessageDelegate{
    func messageButtonTapped(cell: TopicCell)
}

class TopicCell: UITableViewCell {
    
    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var TopicTitleView: UITextView!
    @IBOutlet weak var TopicMessageLabel: UILabel!
    @IBOutlet weak var TopicPictureImageView: UIImageView!
    var TopicUID: String?
    var TopicTitle: String?
    var TopicType: String?
    var TopicP: UIImage?
    var tapBlock: dispatch_block_t?
    var SaveTopicUID: String?
    var followTopicUID: String?
    var followTopicDelegate: FollowTopicDelegate?
    var replyTopicDelegate: ReplyTopicDelegate?
    var messageDelegate: MessageDelegate?
 
    @IBOutlet weak var SeeMessageButton: UIButton!
    
    @IBOutlet weak var ReplyButton: UIButton!
    
    @IBOutlet weak var FollowButton: UIButton!
    
    /**
     Replay button without use in this project , will be chnage in the future
    **/
    @IBAction func ReplayButtonAction(sender: AnyObject) {
        
        if let delegate = replyTopicDelegate{
            delegate.replyButtonTapped(self)
        }
        
    }
    
    /**
     Follow button function with delegate for Topic Cell
    **/
    @IBAction func FollowButtonAction(sender: AnyObject) {
        if let delegate = followTopicDelegate{
           delegate.followTopicTapped(self)
        }
    }
  
    @IBOutlet weak var animationView: CSAnimationView!
    
    var topic: Topic!{
        didSet{
            self.updateUI()
        }
    }
    
    
    /**
      Update the Topic Cell UI : Button && Background
    **/
    func updateUI()
    {
        ReplyButton.layer.borderWidth = 1
        ReplyButton.layer.cornerRadius = 5
        ReplyButton.clipsToBounds = true
        
        FollowButton.layer.borderWidth = 1
        FollowButton.layer.cornerRadius = 5
        FollowButton.clipsToBounds = true
        
        SeeMessageButton.layer.borderWidth = 1
        SeeMessageButton.layer.cornerRadius = 5
        SeeMessageButton.clipsToBounds = true
        
        backgroundCardView.backgroundColor = UIColor.whiteColor()
        contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0,alpha: 1.0 )
        backgroundCardView.layer.cornerRadius = 3.0
        backgroundCardView.layer.masksToBounds = false
        backgroundCardView.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.2).CGColor
        backgroundCardView.layer.shadowOffset = CGSize(width: 0,height: 0)
        backgroundCardView.layer.shadowOpacity = 0.8        
    }
    
    
    
    
}




















