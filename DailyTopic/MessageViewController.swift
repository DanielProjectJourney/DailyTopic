//
//  MessageViewController.swift
//  DailyTopic
//
//  Created by Daniel on 21/05/2016.
//  Copyright © 2016 Daniel. All rights reserved.
//

import UIKit
/**
 Firebase: Online Database
 https://www.firebase.com/
 **/
import Firebase

class MessageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var currentMessageLists: NSArray?
    
    //Back to Home Page Button Action
    @IBAction func BackToHomeAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //TableView embbed in MessageViewController
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var TopicMessageTitle: UILabel!
    
    @IBOutlet weak var ImageView: UIImageView!
    
    var TopicUID : String?
    var TopicMessageNumber: Int?
    var TopicPicture: UIImage?
    var TopicTitle: String?
    var TopicType: String?
    var TopicCategory: String?
    
    required init?(coder aDecoder:NSCoder){
        self.currentMessageLists = [String]()
        super.init(coder:aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TopicMessageTitle.text = TopicTitle!
        self.ImageView.image = TopicPicture!
        
        //Retrieving the data form Published List
        let messageRef = Firebase(url: "https://dailytopic-daniel.firebaseio.com/DailyTopic/TotalTopics/Published/\(self.TopicUID!)/MessagesComment")
        
        messageRef.observeEventType(.Value, withBlock: { snapshot in
            
            var newItems = [String]()
            
            for item in snapshot.children{
                
                let topicItem = item as! FDataSnapshot
                
                let topicMessage = topicItem.value.description
                
                newItems.append(topicMessage)
                
            }
            
            self.currentMessageLists = newItems
            self.tableView.reloadData()
        })

    }
    
  
     func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentMessageLists?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cellIdentifier = "MessageCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,forIndexPath: indexPath) as! MessageTableViewCell
        
        //Configure the cell...
        let m: String = self.currentMessageLists![indexPath.row] as! String
        cell.UserReplyMessageLabel.text = m
        return cell
    }
    
    
    
    
    
    
    
    
    
    

    
    
}





















