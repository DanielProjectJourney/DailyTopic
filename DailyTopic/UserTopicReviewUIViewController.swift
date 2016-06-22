//
//  UserTopicReviewUIViewController.swift
//  DailyTopic
//
//  Created by Daniel on 8/06/2016.
//  Copyright © 2016 Daniel. All rights reserved.
//

import UIKit
/**
 Firebase: Online Database
 https://www.firebase.com/
 **/
import Firebase

class UserTopicReviewUIViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //Back to Upper image
    @IBAction func backToUserProfileButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBOutlet weak var tableView: UITableView!
    
    var TopicUID : String?
    var TopicMessageNumber: Int?
    var TopicPicture: UIImage?
    var TopicTitle: String?
    var TopicType: String?
    var TopicCategory: String?
    
    var currentMessageLists: NSArray?
    
    @IBOutlet weak var userTopicTitle: UILabel!
    @IBOutlet weak var userTopicPicture: UIImageView!
    
    
    required init?(coder aDecoder: NSCoder){
        self.currentMessageLists = [String]()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userTopicTitle.text = self.TopicTitle!
        self.userTopicPicture.image = self.TopicPicture
        
        //Get the Topic Message form Published List
        let messageRef = Firebase(url: "https://dailytopic-daniel.firebaseio.com/DailyTopic/TotalTopics/Published/\(self.TopicUID!)/MessagesComment")
        
        let secretMessageRef = Firebase(url: "https://dailytopic-daniel.firebaseio.com/DailyTopic/TotalTopics/Secret/\(self.TopicUID!)/MessagesComment")
        
        messageRef.observeEventType(.Value, withBlock: { snapshot in
            
            var newItems = [String]()
            
            for item in snapshot.children{
                
                let topicItem = item as! FDataSnapshot
                
                let topicMessage = topicItem.value.description
                
                newItems.append(topicMessage)
                
            }
            self.currentMessageLists = newItems
            
            if self.currentMessageLists!.count == 0
            {
                secretMessageRef.observeEventType(.Value, withBlock: { snapshot in
                    
                    var secretItems = [String]()
                    
                    for item in snapshot.children{
                        
                        let topicItem = item as! FDataSnapshot
                        
                        let topicMessage = topicItem.value.description
                        
                        secretItems.append(topicMessage)
                        
                    }
                    
                    self.currentMessageLists = secretItems
                   self.tableView.reloadData()
                })
            }
        })

    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.currentMessageLists?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cellIdentifier = "UserTopicMessageCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,forIndexPath: indexPath) as! UserTopicMessageUITableViewCell
        
        //Configure the cell...
        
        let utm: String = self.currentMessageLists![indexPath.row] as! String
      
        cell.messageLabel.text = utm
        return cell
    }
    
    
}
