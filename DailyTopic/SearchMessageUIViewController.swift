//
//  SearchMessageUIViewController.swift
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

class SearchMessageUIViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SaveTopicDelegate {
    
    //The Array save the Topic Message
    var currentMessageLists: NSArray?

    @IBAction func backToSearchResultButtonAction(sender: AnyObject) {
          self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //UITableView Embedded in SearchMessageUIView
    @IBOutlet weak var tableView: UITableView!

    //Search Topic Title
    @IBOutlet weak var searchTopicTitle: UILabel!

    //Search Topic Picture
    @IBOutlet weak var searchTopicPicture: UIImageView!
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
        self.searchTopicTitle.text = TopicTitle!
        self.searchTopicPicture.image = TopicPicture!
        
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
        
        print(self.TopicType!)
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    /**
        Idenfity the number of rows in section by Topic Type : "Secret" or "Published"
    **/
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var numberOfCell: Int?
        
        if self.TopicType! == "Secret"
        {
           numberOfCell = 1
        }
        
        if self.TopicType! == "Published"
        {
           numberOfCell = (self.currentMessageLists?.count)!
        }
        
        return numberOfCell!
        
    }
    
    /**
        Set the cell by Topic Type
    **/

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cellIdentifier = "SearchMessageCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,forIndexPath: indexPath) as! SearchMessageTableCell
        
        if self.TopicType! == "Secret"
        {
            cell.searchMessageLabel.text = "Please Wait the Messages is more than 20"
           
            //Save Topic Delegate
            if cell.saveTopicDelegate == nil {
                cell.saveTopicDelegate = self
            }
        
        }
        
        if self.TopicType! == "Published"
        {
            //Configure the cell...
            let m: String = self.currentMessageLists![indexPath.row] as! String
            cell.searchMessageLabel.text = m
            cell.saveButton.hidden = true
            
            //Save Topic Delegate
            if cell.saveTopicDelegate == nil {
                cell.saveTopicDelegate = self
            }
            
        }
        
        return cell
    }
    
    
    
    /**
     MARK: - Follow Topic Delegate
     **/
    func saveTopicTapped(cell: SearchMessageTableCell){
        
        let authData = CURRENT_USER.authData.description.componentsSeparatedByString(" ")
        let uid = authData[1]
        let FollowTopicRef = Firebase(url: "https://dailytopic-daniel.firebaseio.com/DailyTopic/Users/\(uid)/FollowTopicUID")
        
        if self.TopicType! == "Secret"
        {
            
            let saveTopicUID = self.TopicUID!
            let saveTopicTitle = self.TopicTitle!
            self.showAlertForTopicUID(saveTopicTitle)
            FollowTopicRef.childByAutoId().setValue(saveTopicUID)
        }
        
        //If the topic's type is Published
        if self.TopicType! == "Published"
        {
        
            let saveTopicUID = self.TopicUID!
            let saveTopicTitle = self.TopicTitle!
            self.showAlertForTopicUID(saveTopicTitle)
            FollowTopicRef.childByAutoId().setValue(saveTopicUID)
            
        }
    }
    
    
    //MARK: - Save Topic Delegate Extracted Method
    func showAlertForTopicUID(TopicTitle: String)
    {
        
        let alert = UIAlertController(
            title: "Follow Sucessfully ",
            message: TopicTitle,
            preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Gotcha!", style: UIAlertActionStyle.Default, handler: { (test) -> Void in
        }))
        
        self.presentViewController(
            alert,
            animated: true,
            completion: nil)
    }
    
    
}










