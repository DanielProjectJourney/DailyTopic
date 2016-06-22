//
//  SearchResultViewController.swift
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

class SearchResultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var selectedType = "Secret"
    var topicCategory: String?
    var secretTopicLists: NSArray?
    var publishedTopicLists: NSArray?
    
    //Selected Topic Type : "Secret" and "Published"
    @IBAction func SegmentAction(sender: AnyObject) {
        self.selectedType = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!
        if(self.selectedType == "Sercet")
        {
            
        }
        
        if(self.selectedType == "Published")
        {
            
        }
        tableView.reloadData()
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var BackToSearchButton: UIBarButtonItem!
    
    //Back to the Upper Page
    @IBAction func BackToSeachAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    required init?(coder aDecoder:NSCoder){
        self.secretTopicLists = [Topic]()
        self.publishedTopicLists = [Topic]()
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.topicCategory!)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Retrieving the data form Secret List in database
        let secretTopicRef = Firebase(url:"https://dailytopic-daniel.firebaseio.com/DailyTopic/TotalTopics/Secret/")
        
        secretTopicRef.observeEventType(.Value, withBlock: { snapshot in
            
            var newItems = [Topic]()
            
            for item in snapshot.children{
                
                let topicItem = item as! FDataSnapshot
                
                
                let topicTitle  = topicItem.value.objectForKey("TopicTitle") as! String
                let base64String = topicItem.value.objectForKey("TopicPicture") as! String
                
                let FirebaseTopicCategory = topicItem.value.objectForKey("TopicCategory") as! String
                
                let topicImage = self.convertBase64ToImage(base64String)
                
                let topicType = "Secret"
                
                let topicMessageCount = topicItem.value.objectForKey("MessagesCount") as! Int
                
                let topicID = topicItem.key
                
                
                if FirebaseTopicCategory == self.topicCategory!
                {
                    let topic = Topic(newID: topicID, newTitle: topicTitle, newType: topicType, newPicture: topicImage,newMessageCount: topicMessageCount,newCategory: FirebaseTopicCategory  )
                    newItems.append(topic)
                }
                
                
            }
            
            self.secretTopicLists = newItems
            self.tableView.reloadData()
        })
        
        
        
        
        //Retrieving the data form Published List in database
        let publishedTopicRef = Firebase(url:"https://dailytopic-daniel.firebaseio.com/DailyTopic/TotalTopics/Published/")
        
        publishedTopicRef.observeEventType(.Value, withBlock: { snapshot in
            
            var newItems = [Topic]()
            
            for item in snapshot.children{
                
                let topicItem = item as! FDataSnapshot
                
                
                let topicTitle  = topicItem.value.objectForKey("TopicTitle") as! String
                let base64String = topicItem.value.objectForKey("TopicPicture") as! String
                
                let FirebaseTopicCategory = topicItem.value.objectForKey("TopicCategory") as! String
                
                let topicImage = self.convertBase64ToImage(base64String)
                
                let topicType = "Secret"
                
                let topicMessageCount = topicItem.value.objectForKey("MessagesCount") as! Int
                
                let topicID = topicItem.key
                
                
                if FirebaseTopicCategory == self.topicCategory!
                {
                    let topic = Topic(newID: topicID, newTitle: topicTitle, newType: topicType, newPicture: topicImage,newMessageCount: topicMessageCount,newCategory: FirebaseTopicCategory  )
                    newItems.append(topic)
                }
                
                
            }
            
            self.publishedTopicLists = newItems
            self.tableView.reloadData()
        })
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /**
     Identify the Topic whether is Secreor or Published and set the number of rows in Section
    **/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var row:Int?
        
        if selectedType == "Secret"
        {
            if self.secretTopicLists?.count == nil{
                row = 0
            }else{
                row = self.secretTopicLists!.count
            }
            
        }
        
        if selectedType == "Published"
        {
            
            
            if self.publishedTopicLists?.count == nil
            {
                row = 0
            }else{
                row = self.publishedTopicLists!.count
            }
            
        }
        
        return row!
    }
    
    
    /**
       Secret Topic or Published Topic cell
    **/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifer = "SearchResultCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifer,forIndexPath: indexPath) as! SearchResultUITableViewCell
        
        
        //        cell.topicTitleLabel.text = searchTopicType!
        if selectedType == "Secret"
        {
            let ts:Topic = self.secretTopicLists![indexPath.row] as! Topic
            cell.topicImageView.image = ts.picture!
            cell.topicTitleLabel.text = ts.title!
        }
        
        if selectedType == "Published"
        {
            let tp:Topic = self.publishedTopicLists![indexPath.row] as! Topic
            cell.topicImageView.image = tp.picture!
            cell.topicTitleLabel.text = tp.title!
        }
        return cell
    }
    
    /**
     Segue Search
     **/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SearchMessageSegue"
        {
            let  indexPath = self.tableView.indexPathForSelectedRow!.row
            
            let controller: SearchMessageUIViewController = segue.destinationViewController as! SearchMessageUIViewController
            
            if selectedType == "Secret"
            {
                let searchMessage: Topic = self.secretTopicLists! [indexPath] as! Topic
                controller.TopicUID = searchMessage.id!
                controller.TopicTitle = searchMessage.title!
                controller.TopicPicture = searchMessage.picture!
                controller.TopicType = "Secret"
                
            }
            
            if selectedType == "Published"
            {
                let searchMessage: Topic = self.publishedTopicLists![indexPath] as! Topic
                controller.TopicUID = searchMessage.id!
                controller.TopicTitle = searchMessage.title!
                controller.TopicPicture = searchMessage.picture!
                controller.TopicType = "Published"
            }
            
        }
        
    }
    
    
    //Conver images into base64 and keep them into string
    
    func convertBase64ToImage(base64String: String) -> UIImage {
        
        let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters )
        
        let decodedImage = UIImage(data: decodedData!)
        
        return decodedImage!
    }
    
    
    
}
