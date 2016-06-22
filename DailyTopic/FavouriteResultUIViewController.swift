//
//  FavouriteResultUIViewController.swift
//  DailyTopic
//
//  Created by Daniel on 7/06/2016.
//  Copyright © 2016 Daniel. All rights reserved.
//

import UIKit
/**
 Firebase: Online Database
 https://www.firebase.com/
 **/
import Firebase

class FavouriteResultUIViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //Save the Topic messages into a Array
    var currentMessageLists: NSArray?

    //Tableview embedded int FavouriteResultUIViewController
    @IBOutlet weak var tableView: UITableView!
    
    //Back to the upper page
    @IBAction func returnButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Favourite Topic Title
    @IBOutlet weak var FavouriteTopicTitle: UILabel!
    
    //Favourite Topic Picture
    @IBOutlet weak var FavouriteTopicPicture: UIImageView!
    
    var TopicUID : String?
    var TopicMessageNumber: Int?
    var TopicPicture: UIImage?
    var TopicTitle: String?
    var TopicType: String?
    var TopicCategory: String?
    
    //Inintial Variable
    required init?(coder aDecoder:NSCoder){
        self.currentMessageLists = [String]()
        super.init(coder:aDecoder)
    }
    
    //Loading Page
    override func viewDidLoad() {
        super.viewDidLoad()
        self.FavouriteTopicTitle.text = self.TopicTitle!
        self.FavouriteTopicPicture.image = self.TopicPicture
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
    
    //Set the nubmer of sections in TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    
    //Set the number of rows in Section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var favouriteMessage: Int?
        
        if self.TopicType! == "Secret"
        {
            favouriteMessage = 1
        }
        
        if self.TopicType! == "Published"
        {
            favouriteMessage = (currentMessageLists?.count)!
        }
        
        return favouriteMessage!
    }
    
    
    //Set the FavouriteResulteTable
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cellIdentifier = "FavouriteMessageCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,forIndexPath: indexPath) as! FavouriteResulteTableCell
        
        if self.TopicType! == "Secret"
        {
            cell.FavouriteMessageLabel.text = "Please waitting the Message are more than 20"
        }
        
        if self.TopicType! == "Published"
        {
            //Configure the cell...
            let m: String = self.currentMessageLists![indexPath.row] as! String
            cell.FavouriteMessageLabel.text = m
        }
        
        
        
        return cell
    }
    
}




















