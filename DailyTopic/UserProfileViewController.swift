//
//  UserProfileViewController.swift
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

class UserProfileViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var addImageButton: UIButton!
    
    var currentUserTopicLists:NSArray?
    
    @IBOutlet weak var tableView: UITableView!
    
    //Inital Method
    required init?(coder aDecoder: NSCoder){
        self.currentUserTopicLists = [Topic]()
        super.init(coder: aDecoder)
    }
    
    //Selecte the Picture from the Photo Library
    @IBAction func addImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.editing = false;
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }

    //Selecte a picture as the icon
    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLaabel: UILabel!
    private let leftAndRightPaddings: CGFloat = 8.0
    private let numberOfItemsPerRow: CGFloat = 3.0
    private let heightAdjustment: CGFloat = 30.0
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.cornerRadius = 5
        logoutButton.clipsToBounds = true
        
        //Get the User Information from the Firebase
        
        let authData = CURRENT_USER.authData.description.componentsSeparatedByString(" ")
        
        let uid = authData[1]
        
        let ref = Firebase(url:"https://dailytopic-daniel.firebaseio.com/DailyTopic/Users/" + uid)
    
        ref.observeEventType(.Value, withBlock: { snapshot in
         
        self.userNameLabel.text  = snapshot.value.objectForKey("UserName") as? String
        self.userEmailLaabel.text = snapshot.value.objectForKey("UserEmail") as? String
        },withCancelBlock: { error in
            print(error.description)
        })
     
      

        
        
        //Get the User Topic Information
        let UserTopicRef = Firebase(url:"https://dailytopic-daniel.firebaseio.com/DailyTopic/Users/\(uid)/Topic" )
        
        UserTopicRef.observeEventType(.Value, withBlock: { snapshot in
            
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
            
            self.currentUserTopicLists = newItems
            self.tableView.reloadData()
        })
        
    
        
        
         
    }
    
    //Log out button
    @IBAction func logoutAction(sender: AnyObject) {
        CURRENT_USER.unauth()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        self.logoutButton.hidden = true
        self.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Slected the Head image function
    //Reference:https//www.youtube.com/watch?v=O4QVAmDYvkU
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.selectedImage.image = image
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.currentUserTopicLists?.count)!
    }
    
    
        
    
    /**
        User Profile TableView Cell
    **/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cellIdentifier = "UserProfileTopicCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,forIndexPath:indexPath) as! UserProfileTopicUITableViewCell
        //Configure the cell...
        let ut:Topic = self.currentUserTopicLists![indexPath.row] as! Topic
        cell.UserTopicImage.image = ut.picture
        cell.UserTopicTitle.text = ut.title
        return cell
    }
    
    /**
     UserTopicSegue
     **/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "UserTopicSegue"
        {
            let indexPath = self.tableView.indexPathForSelectedRow!.row
            
            let controller: UserTopicReviewUIViewController = segue.destinationViewController as! UserTopicReviewUIViewController
            
            let userTopic: Topic = self.currentUserTopicLists![indexPath] as! Topic
           
            
            controller.TopicTitle = userTopic.title
            controller.TopicPicture = userTopic.picture
            controller.TopicUID = userTopic.id
         
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















