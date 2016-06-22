//
//  ReplyViewController.swift
//  DailyTopic
//
//  Created by Daniel on 9/05/2016.
//  Copyright © 2016 Daniel. All rights reserved.
//

import UIKit
/**
 Firebase: Online Database
 https://www.firebase.com/
 **/
import Firebase

class ReplyViewController: UIViewController,UITextViewDelegate{

    var TopicUID : String?
    var TopicMessageNumber: Int?
    var TopicPictureString: String?
    var TopicTitle: String?
    var TopicType: String?
    var TopicCategory: String?
    
    @IBOutlet weak var ReplyTitleLabel: UITextView!
    
    @IBOutlet weak var ReplyPictureImageView: UIImageView!
    
    @IBOutlet weak var ReplyMessageTextView: UITextView!
    
    //Back to upper page
    @IBAction func BackHomeButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Post the User topic into the Firebase
    @IBAction func PostRelyButton(sender: AnyObject) {
        
        //When Message Count less than 20 (It means Topic not Popular)
        if TopicMessageNumber! < 20
        {
        let ref = Firebase(url: "https://dailytopic-daniel.firebaseio.com/DailyTopic/TotalTopics/Secret/\(TopicUID!)")
        
        //Save the Topic Message Comment
        let topic = ref.childByAppendingPath("MessagesComment")
        
        let message = ReplyMessageTextView.text!
        
        print("Message:\(message)")
        
        topic.childByAutoId().setValue(message)
        
            //Save the Topic Message Count
            let MessageCount = TopicMessageNumber! + 1
     
            
            ref.childByAppendingPath("MessagesCount").setValue(MessageCount)
        }
        
        //When Topic Message equal 20
        if TopicMessageNumber == 20
        {
            let ref = Firebase(url: "https://dailytopic-daniel.firebaseio.com/DailyTopic/TotalTopics/Published/\(TopicUID!)")
            
        
            
            //Save the Topic Message Comment
            let topic = ref.childByAppendingPath("MessagesComment")
            let message = ReplyMessageTextView.text!
            let title = self.TopicTitle!
            let picture = self.TopicPictureString!
            let category = self.TopicCategory!
            topic.childByAutoId().setValue(message)
            
            
            //Save the Topic Message Count
            let MessageCount = 21
        
            ref.childByAppendingPath("MessagesCount").setValue(MessageCount)
            ref.childByAppendingPath("TopicPicture").setValue(picture)
            ref.childByAppendingPath("TopicTitle").setValue(title)
            ref.childByAppendingPath("TopicType").setValue("Published")
            ref.childByAppendingPath("TopicCategory").setValue(category)
            
            
            //Get the before 20 Message From Secret Topic
            
            let TopicMessagesRef = Firebase(url:"https://dailytopic-daniel.firebaseio.com/DailyTopic/TotalTopics/Secret/\(TopicUID!)/MessagesComment")
            
        
            TopicMessagesRef.observeEventType(.Value, withBlock: { snapshot in
                
                for item in snapshot.children{
                    
                    let topicItem = item as! FDataSnapshot
                    
                
                    topic.childByAppendingPath(topicItem.key).setValue(topicItem.value)
                    
                }
             
            })
            
            //Delete Topic in Secret
            let SercretTopicRef =  Firebase(url:"https://dailytopic-daniel.firebaseio.com/DailyTopic/TotalTopics/Secret/\(TopicUID!)")
            
            SercretTopicRef.removeValue()
            
            //Update the User Topic Type from "Secret" become "Published"
            let authData = CURRENT_USER.authData.description.componentsSeparatedByString(" ")
            let uid = authData[1]
            
            let DeleteUerTopicRef =  Firebase(url:"https://dailytopic-daniel.firebaseio.com/DailyTopic/Users/\(uid)/Topic/\(TopicUID!)" )
            
            
             DeleteUerTopicRef.childByAppendingPath("TopicType").setValue("Published")
            
            
        }
        
        
        
        //When Topic Message more than 20
        if TopicMessageNumber > 20
        {
            let ref = Firebase(url: "https://dailytopic-daniel.firebaseio.com/DailyTopic/TotalTopics/Published/\(TopicUID!)")
            
            
           
            
            //Save the Topic Message Comment
            let topic = ref.childByAppendingPath("MessagesComment")
            let message = ReplyMessageTextView.text!
           
            topic.childByAutoId().setValue(message)
            
            
         
            
            //Save the Topic Message Count
            let MessageCount = TopicMessageNumber! + 1
            
            
            ref.childByAppendingPath("MessagesCount").setValue(MessageCount)
           
            
            
            //Update the User Topic Type from "Secret" become "Published"
            let authData = CURRENT_USER.authData.description.componentsSeparatedByString(" ")
            let uid = authData[1]
            
            let DeleteUerTopicRef =  Firebase(url:"https://dailytopic-daniel.firebaseio.com/DailyTopic/Users/\(uid)/Topic/\(TopicUID!)" )
            
            
            DeleteUerTopicRef.childByAppendingPath("TopicType").setValue("Published")
        }
    
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("TopicMessagenubmer: \(TopicMessageNumber)")
        
        //Update the User Topic Type from "Secret" become "Published"
        let authData = CURRENT_USER.authData.description.componentsSeparatedByString(" ")
        let uid = authData[1]
        
        let DeleteUerTopicRef =  Firebase(url:"https://dailytopic-daniel.firebaseio.com/DailyTopic/Users/\(uid)/Topic/\(TopicUID!)" )
        
        print(uid)
        print(TopicUID!)
        
        
        DeleteUerTopicRef.childByAppendingPath("TopicType").setValue("Published")
        
        
        for subView in self.ReplyMessageTextView.subviews
        {
            for subsubView in subView.subviews
            {
                if let textField = subsubView as? UITextField
                {
                    textField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Leave a Message", comment: ""),attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
                    
                    textField.textColor = UIColor.redColor()
                }
            }
        }
        
    }
    
    public func textViewShouldEndEditing(textView: UITextView) -> Bool
    {
        return true
    }
    
    //Delay Function
    func delay(time: Double, closure: () -> () ){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
