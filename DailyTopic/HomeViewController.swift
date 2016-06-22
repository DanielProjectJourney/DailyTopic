//
//  HomeViewController.swift
//  DailyTopic
//
//  Created by Daniel on 7/05/2016.
//  Copyright © 2016 Daniel. All rights reserved.
//

import UIKit
/**
 Firebase: Online Database
 https://www.firebase.com/
 **/
import Firebase
/**
 Firebase: Online Database
 https://www.firebase.com/
 **/
import NVActivityIndicatorView

public class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,FollowTopicDelegate,ReplyTopicDelegate,MessageDelegate{

    //Selected the type of Topic : "Secret" or "Published"
    var selectedType = "Secret"
    var topicsList : NSArray?
    var favouriteTopicsList: NSArray?
    var publishedTopicsList: NSArray?
    var indexPath: Int!
    //Loading Indicator Animation Initialization
    let activityIndicatorView: NVActivityIndicatorView?
    let frame = CGRect(x: 120, y: 250, width: 60,height: 60)
    
    var selectedRow: Int?
    var replyRow: Int?
    
  
    
    required public init?(coder aDecoder: NSCoder)
    {
        self.topicsList = [Topic]()
        self.publishedTopicsList = [Topic]()
        //Initial the Loading Indicator
        activityIndicatorView = NVActivityIndicatorView(frame: frame,type: .LineScale,color: UIColor.redColor())
        super.init(coder: aDecoder)
    }
    
    /**
        Creat the Table into the UIViewController
    **/
    @IBOutlet weak var tableView: UITableView!

    //Segmented Aciont Listener
    @IBAction func segmentedAction(sender: UISegmentedControl) {
       selectedType = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!
        
       
       tableView.reloadData()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        //Start Loading Indicator Animation
        self.view.addSubview(activityIndicatorView!)
        activityIndicatorView!.startAnimation()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        
        //Retrieving the data form Secret List in Firebase
        let firebase = Firebase(url:"https://dailytopic-daniel.firebaseio.com/DailyTopic/TotalTopics/Secret/")
        firebase.observeEventType(.Value, withBlock: { snapshot in
            
            var newItems = [Topic]()
        
            for item in snapshot.children{
                
                let topicItem = item as! FDataSnapshot
                
                
                let topicTitle  = topicItem.value.objectForKey("TopicTitle") as! String
                let base64String = topicItem.value.objectForKey("TopicPicture") as! String
                
                let topicCategory = topicItem.value.objectForKey("TopicCategory") as! String
                
                let topicImage = self.convertBase64ToImage(base64String)
                
                let topicType = "Secret"
                
                let topicMessageCount = topicItem.value.objectForKey("MessagesCount") as! Int
                
                let topicID = topicItem.key
                
                
                
                let topic = Topic(newID: topicID, newTitle: topicTitle, newType: topicType, newPicture: topicImage,newMessageCount: topicMessageCount,newCategory: topicCategory  )
                
                newItems.append(topic)
            
            }
            
            self.topicsList = newItems
            self.tableView.reloadData()
        })
        
       
        //   Retrieving data form published list in Firebase
        let PublishedTopicsRef = Firebase(url:"https://dailytopic-daniel.firebaseio.com/DailyTopic/TotalTopics/Published")
        PublishedTopicsRef.observeEventType(.Value, withBlock: { snapshot in
            
            
            var newItems = [Topic]()
            
            for item in snapshot.children{
                
                let topicItem = item as! FDataSnapshot
                
                var topicTitle = "Please wait"
                var topicImage = UIImage(named: "home")
                var topicMessageCount = 21
                var topicCatory = "Please wait"
                
                
                if topicItem.childSnapshotForPath("TopicTitle").exists()
                {
                  topicTitle  = topicItem.value.objectForKey("TopicTitle") as! String
                }
            
                if topicItem.childSnapshotForPath("TopicPicture").exists()
                {
                    let base64String = topicItem.value.objectForKey("TopicPicture") as! String
                    topicImage = self.convertBase64ToImage(base64String)
                }
                
                if topicItem.childSnapshotForPath("Messagescount").exists()
                {
                     topicMessageCount = topicItem.value.objectForKey("MessagesCount") as! Int

                }
                
                if topicItem.childSnapshotForPath("TopicCategory").exists()
                {
                    topicCatory = topicItem.value.objectForKey("TopicCategory") as! String
                }
                
             
                let topicType = "Publishesd"
                
                
                let topicID = topicItem.key
                
                let topic = Topic(newID: topicID, newTitle: topicTitle, newType: topicType, newPicture: topicImage!,newMessageCount: topicMessageCount,newCategory: topicCatory  )
                
                newItems.append(topic)
                
            }
            
            self.publishedTopicsList = newItems
            self.tableView.reloadData()
        })
       
        
    }
  
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        var row:Int?
        
         if selectedType == "Secret"
         {
            if self.topicsList?.count == nil{
                row = 0
            }else{
                row = self.topicsList!.count
            }
            
         }
        
        
        if selectedType == "Published"
        {
            
            
            if self.publishedTopicsList?.count == nil
            {
                row = 0
            }else{
                row = self.publishedTopicsList!.count
            }
            
        }
        
    
    
     
        return row!
    }

    
    //Animate Custom UITableViewCell
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, cellForRowAtIndexPath indexPath:NSIndexPath){
        // 1.Set the initial state of the cell
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity,-250,20,0)
        cell.layer.transform = transform
        
        
        // 2.UIView animation method to change to the final state of the cell
        UIView.animateWithDuration(1.0){
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    
    
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("TopicCell",forIndexPath: indexPath) as! TopicCell
            
            //If the Topic type is Secret , put the data into cell
            if selectedType == "Secret"
            {
         
              let ts:Topic = self.topicsList![indexPath.row] as! Topic
              cell.TopicTitleView.text = ts.title
              cell.TopicPictureImageView.image = ts.picture
              cell.TopicUID = ts.id
              cell.TopicMessageLabel.text =  String(ts.message!) + " Messages"
              cell.FollowButton.tag = indexPath.row
              cell.updateUI()
              activityIndicatorView!.stopAnimation()
              cell.ReplyButton.tag = indexPath.row
                
              cell.SeeMessageButton.hidden = true
           
              cell.SeeMessageButton.tag = indexPath.row
            
                //Follow Topic Delegate
                if cell.followTopicDelegate == nil {
                    cell.followTopicDelegate = self
                }
                
                //Replay Topic Delegate
                if cell.replyTopicDelegate == nil{
                    cell.replyTopicDelegate = self
                }
                
                //Message Delegate
                if cell.messageDelegate == nil{
                    cell.messageDelegate = self
                }
                
                
            }
            
            //If the topic type is published is
            if selectedType == "Published"
            {
                let tp:Topic = self.publishedTopicsList![indexPath.row] as! Topic
                cell.TopicTitleView.text = tp.title
                cell.TopicPictureImageView.image = tp.picture
                cell.TopicUID = tp.id
                cell.TopicMessageLabel.text = String(tp.message!) + " Messages"
                cell.updateUI()
                activityIndicatorView!.stopAnimation()
                cell.ReplyButton.tag = indexPath.row
                cell.SeeMessageButton.tag = indexPath.row
            
                 cell.SeeMessageButton.hidden = false
                //Use Follow Topic Delegate
                if cell.followTopicDelegate == nil {
                    cell.followTopicDelegate = self
                }
                
                //Replay Topic Delegate
                if cell.replyTopicDelegate == nil{
                    cell.replyTopicDelegate = self
                }
                
                //Message Delegate
                if cell.messageDelegate == nil{
                    cell.messageDelegate = self
                }
                
            }
            
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("NoTopicCell",forIndexPath: indexPath)
            
            return cell
            
        }
        
    }
    
    
    
    //Conver images into base64 and keep them into string
    
    func convertBase64ToImage(base64String: String) -> UIImage {
        
        let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters )
        
        let decodedImage = UIImage(data: decodedData!)
        
        return decodedImage!
    }
    
    //Transmit the value to Reply View
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        //Reply Button function
        if segue.identifier == "ReplySegue"
        {
            let  indexPath = self.tableView.indexPathForSelectedRow!.row
            
            let controller: ReplyViewController = segue.destinationViewController as! ReplyViewController
           
            //If the topic's type is Secret
            if selectedType == "Secret"
            {
             
                let replyTopic: Topic = self.topicsList![indexPath] as! Topic
                controller.TopicUID = replyTopic.id!
                controller.TopicMessageNumber = replyTopic.message!
                controller.TopicTitle = replyTopic.title!
                controller.TopicCategory = replyTopic.category!
                controller.TopicPictureString = convertImageToBase64(replyTopic.picture!)
                
            }
            
            //If the topic's type is Published
            if selectedType == "Published"
            {
                let replyTopic: Topic = self.publishedTopicsList![indexPath] as! Topic
                controller.TopicUID = replyTopic.id!
                controller.TopicMessageNumber = replyTopic.message!
                controller.TopicTitle = replyTopic.title!
                controller.TopicCategory = replyTopic.category!
                controller.TopicPictureString = convertImageToBase64(replyTopic.picture!)
            }
        }
        
        
        //Message Button Function
        if segue.identifier == "MessageSegue"
        {
            let indexPath = self.tableView.indexPathForSelectedRow!.row
            
            let controller: MessageViewController = segue.destinationViewController as! MessageViewController
            
            //If the topic Type is Published
            if selectedType == "Published"
            {
                let topicMessage: Topic = self.publishedTopicsList![indexPath] as! Topic
                controller.TopicUID = topicMessage.id!
                controller.TopicTitle = topicMessage.title!
                controller.TopicPicture = topicMessage.picture
            }
            
        }
        
    }
    
    /**
        MARK: - Follow Topic Delegate
    **/
    func followTopicTapped(cell: TopicCell){
      
        let authData = CURRENT_USER.authData.description.componentsSeparatedByString(" ")
        let uid = authData[1]
        let FollowTopicRef = Firebase(url: "https://dailytopic-daniel.firebaseio.com/DailyTopic/Users/\(uid)/FollowTopicUID")
        
        if selectedType == "Secret"
        {
           
            let indexPath = self.tableView.indexPathForCell(cell)!.row
            let followTopic: Topic = self.topicsList![indexPath] as! Topic
            let followTopicUID = followTopic.id!
            let followTopicTitle = followTopic.title!
            self.showAlertForTopicUID(followTopicTitle)
            FollowTopicRef.childByAutoId().setValue(followTopicUID)
        }
        
        //If the topic's type is Published
        if selectedType == "Published"
        {
       
            let indexPath = self.tableView.indexPathForCell(cell)!.row
            let followTopic: Topic = self.publishedTopicsList![indexPath] as! Topic
            let followTopicUID = followTopic.id!
            let followTopicTitle = followTopic.title!
            self.showAlertForTopicUID(followTopicTitle)
            FollowTopicRef.childByAutoId().setValue(followTopicUID)
            
        }
    }
    
    
    //MARK: - Reply Topic Delegate
    func replyButtonTapped(cell: TopicCell) -> Int {
        let indexPath = self.tableView.indexPathForCell(cell)!.row
        return indexPath
    }
    
 
    
    //Message: - Message Delegate
    func messageButtonTapped(cell: TopicCell) {
        print("OK")
    }
    
    //MARK: - Follow Topic Delegate Extracted Method
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
    
    
    /** 
        Change the Topic picture into Base64
    **/
    func convertImageToBase64(image: UIImage) -> String{
        var imageData = UIImagePNGRepresentation(image)
        let base64String = imageData?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        return base64String!
    }
    
    //Test topic Type
    public static func identifyTopicType(testTopicType:String) -> Bool{
        
        //Test Topic Type: Secret or Published
        var getTopicType = true
        
        if testTopicType == "Secret"
        {
            //Retrieving the data form Secret List in Firebase
            let firebase = Firebase(url:"https://dailytopic-daniel.firebaseio.com/DailyTopic/TotalTopics/Secret/")
            firebase.observeEventType(.Value, withBlock: { snapshot in
                
                var equalType = true
                
                for item in snapshot.children{
                    
                    let topicItem = item as! FDataSnapshot
                    
                    
                    let topicMessageCount = topicItem.value.objectForKey("MessagesCount") as! Int
                        
                        
                     if topicMessageCount >= 20
                    {
                        equalType = false
                    }
                    
                }
                     getTopicType = equalType
            })
            
       
        }
        
        
        if testTopicType == "Published"
        {
            //Retrieving the data form Secret List in Firebase
            let firebase = Firebase(url:"https://dailytopic-daniel.firebaseio.com/DailyTopic/TotalTopics/Published/")
            firebase.observeEventType(.Value, withBlock: { snapshot in
                
                var equalType = true
                
                for item in snapshot.children{
                    
                    let topicItem = item as! FDataSnapshot
                    
                 
                    let topicMessageCount = topicItem.value.objectForKey("MessagesCount") as! Int
                    
                    
                    if topicMessageCount < 20
                    {
                        equalType = false
                    }
                    
                }
                getTopicType = equalType
            })
            
        }
        
        return getTopicType
    }
    
        
    
        

}





