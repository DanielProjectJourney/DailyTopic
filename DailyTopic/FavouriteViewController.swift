//
//  FavouriteViewController.swift
//  DailyTopic
//
//  Created by Daniel on 4/05/2016.
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

class FavouriteViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    //Topic Image
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    //CollectionView Embedded in UIViewController
    @IBOutlet weak var collectionView: UICollectionView!
    
    var TopicID: String?
    var TopicImage: UIImage?
    var TopicTitle: String?
    var TopicType: String?
    
    //Save the Topic Message
    var TopicMessageCount: Int?
    
    //Save the Topics in Array
    var favouriteTopicsList : NSArray?
    
    //Get the Topic UID From the special User
    var UserFollowTopicsUID : [String]?
    
    //The Function Commbine the Secret Topic and Published Secret
    var newIterms = [Topic]()
    
    //Loading Indicator Animation Initialization
    let activityIndicatorView: NVActivityIndicatorView?
    let frame = CGRect(x: 120, y: 250, width: 60,height: 60)

    
    /**
        Initialize Variable
    **/
    required init?(coder aDecoder: NSCoder)
    {
        self.favouriteTopicsList = [Topic]()
        self.UserFollowTopicsUID = [String]()
        
        //Initialize the loading indicator
        activityIndicatorView = NVActivityIndicatorView(frame: frame,type: .LineScale,color: UIColor.redColor())
        super.init(coder: aDecoder)
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newIterms = []
        //Start Loading Indicator Animation
        self.view.addSubview(activityIndicatorView!)
        activityIndicatorView!.startAnimation()
        
    }
    
    
    /**
        Get the Topic Data from Firebase
    **/
     override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Get the Current User ID
        let authData = CURRENT_USER.authData.description.componentsSeparatedByString(" ")
        let uid = authData[1]
        let UserFollowTopicsRef = Firebase(url:"https://dailytopic-daniel.firebaseio.com/DailyTopic/Users/\(uid)/FollowTopicUID")
        
        //Get the Data from User Follow Topic UID
        UserFollowTopicsRef.observeEventType(.Value, withBlock: { snapshot in
            
            var followTopicsUID = [String]()
            for item in snapshot.children{
                let topicItem = item as! FDataSnapshot
                let topicUID = topicItem.value as! String
                followTopicsUID.append(topicUID)
                
            }
            self.UserFollowTopicsUID = followTopicsUID
            self.collectionView.reloadData()
        })
        
    
        //Get the Data from Secret Topics List in Firebase
        let secretTopicRef = Firebase(url:"https://dailytopic-daniel.firebaseio.com/DailyTopic/TotalTopics/Secret")
        
        let publishedTopicRef = Firebase(url:"https://dailytopic-daniel.firebaseio.com/DailyTopic/TotalTopics/Published")
        
        secretTopicRef.observeEventType(.Value, withBlock: { snapshot in
            
            for item in snapshot.children{
                let topicItem = item as! FDataSnapshot
                let topicID = topicItem.key
        
                for topic in self.UserFollowTopicsUID!{
                    if topicID == topic
                    {
                        let topicTitle  = topicItem.value.objectForKey("TopicTitle") as! String
                        let base64String = topicItem.value.objectForKey("TopicPicture") as! String
                        let topicCategory = topicItem.value.objectForKey("TopicCategory") as! String
                        
                        let topicImage = self.convertBase64ToImage(base64String)
                        
                        let topicType = "Secret"
                        
                        let topicMessageCount = topicItem.value.objectForKey("MessagesCount") as! Int
                        
                        let topic = Topic(newID: topicID, newTitle: topicTitle, newType: topicType, newPicture: topicImage,newMessageCount: topicMessageCount,newCategory: topicCategory  )
                        
                        self.newIterms.append(topic)
                        self.collectionView.reloadData()
             
                    }
                     self.collectionView.reloadData()
                }
            
            }
            
        })
        
        //Get the Data from Published Topics List in Firebase
        publishedTopicRef.observeEventType(.Value, withBlock: { snapshot in
            
            for item in snapshot.children{
                let topicItem = item as! FDataSnapshot
                let topicID = topicItem.key
                
                for topic in self.UserFollowTopicsUID!{
                    if topicID == topic
                    {
                        let topicTitle  = topicItem.value.objectForKey("TopicTitle") as! String
                        let base64String = topicItem.value.objectForKey("TopicPicture") as! String
                        let topicCategory = topicItem.value.objectForKey("TopicCategory") as! String
                        
                        let topicImage = self.convertBase64ToImage(base64String)
                        
                        let topicType = "Published"
                        
                        let topicMessageCount = topicItem.value.objectForKey("MessagesCount") as! Int
                        
                        let topic = Topic(newID: topicID, newTitle: topicTitle, newType: topicType, newPicture: topicImage,newMessageCount: topicMessageCount,newCategory: topicCategory  )
                        
                        self.newIterms.append(topic)
                        self.collectionView.reloadData()
                        
                    }
                     self.collectionView.reloadData()
                }
                
            }
            
        })
        
        
        self.favouriteTopicsList! = []
        self.favouriteTopicsList = self.newIterms
        self.collectionView.reloadData()
    }
    
   
   
    //Set the number of Sections in CollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //set the number
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.favouriteTopicsList!.count
    }
    
    
    //Set the Favourite Result Cell Identifier
    private struct Storyboard{
        static let CellIdentifier = "FavouriteTopicCell"
    }
    
    //Set the cell Item
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.CellIdentifier, forIndexPath: indexPath) as! FavouriteCollectionViewCell
        let ft: Topic = self.favouriteTopicsList![indexPath.row] as! Topic
        cell.FavouriteTopicImage.image = ft.picture!
        cell.FavouriteTopicLabel.text = ft.title!
        activityIndicatorView!.stopAnimation()
        return cell
    }
    
    
    /**
        Set the did  collection cell driven listener
     **/
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("FavouriteMessageSegue", sender: self)
    }
    
    
    /**
      Transmit the data to the FavouriteResultUIViewController
    **/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "FavouriteMessageSegue"
        {
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
            let indexPath = indexPaths[0] as NSIndexPath
            let controller = segue.destinationViewController as! FavouriteResultUIViewController
            
            let favouriteTopic: Topic = self.favouriteTopicsList![indexPath.row] as! Topic
            
            controller.TopicTitle = favouriteTopic.title!
            controller.TopicPicture = favouriteTopic.picture!
            controller.TopicUID = favouriteTopic.id!
            controller.TopicType = favouriteTopic.type!
            
        }
        
    }
    
    /**
        Conver images into base64 and keep them into string
    **/
    func convertBase64ToImage(base64String: String) -> UIImage {
        
        let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters )
        
        let decodedImage = UIImage(data: decodedData!)
        
        return decodedImage!
    }
    
}
