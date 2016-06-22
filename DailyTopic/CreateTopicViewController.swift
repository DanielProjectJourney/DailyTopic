//
//  CreateTopicViewController.swift
//  DailyTopic
//
//  Created by Daniel on 30/04/2016.
//  Copyright © 2016 Daniel. All rights reserved.
//

import UIKit

/**
Youtube:Create Floating Button like Google Apps with Swift 
https://www.youtube.com/watch?v=Euke10fRCAE&index=7&list=PLHmNdpdzx21Fk3YmGzDZ_12XuXj5p9Vm7 
**/
import LiquidFloatingActionButton
/**
 Firebase: Online Database
 https://www.firebase.com/
 **/
import Firebase


var cells = [LiquidFloatingCell]()  //DataSource
var imagePicker = UIImagePickerController()


public class CreateTopicViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource{

    
    @IBOutlet weak var PostTopicButton: UIButton!
    @IBOutlet weak var CategoryPicker: UIPickerView!
    @IBOutlet weak var topicTextfield: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var data: NSData = NSData()
    var categoryArray = ["Game","Music","University Life","Food","Car","Celebrity","Tech","Business","Sport"]
    var selectedCategoryIndex = 0
    var categoryInput = "Game"
    
    //When the user click the Create Topic Button ,Title and Picture will upload into the Firebase
    @IBAction func CreateTopicButton(sender: AnyObject) {
        if topicTextfield.text != "" && imageView.image != nil
        {
            
            //Get the Category
            if (selectedCategoryIndex == 0)
            {
                categoryInput = "Game"
            }
            
            if (selectedCategoryIndex == 1)
            {
                categoryInput = "Music"
            }
            
            if (selectedCategoryIndex == 2)
            {
                categoryInput = "University Life"
            }
            
            if (selectedCategoryIndex == 3)
            {
                categoryInput = "Food"
            }
            
            if (selectedCategoryIndex == 4)
            {
                categoryInput = "Car"
            }
            
            if (selectedCategoryIndex == 5)
            {
                categoryInput = "Celebrity"
            }
            
            if (selectedCategoryIndex == 6)
            {
                categoryInput = "Tech"
            }
            
            if (selectedCategoryIndex == 7)
            {
                categoryInput = "Sport"
            }
            
            
            let topicTitle = topicTextfield.text!
            
            if let image = imageView.image{
                data = UIImageJPEGRepresentation(image, 0.1)!
            }
            
            let base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
            let topicInformation: NSDictionary = ["TopicTitle" : topicTitle,"TopicPicture" : base64String,"TopicType" : "Secret","MessagesCount" : 0,"TopicCategory" : categoryInput]
            
          
            
            //Save data into the Firebase
            let authData = CURRENT_USER.authData.description.componentsSeparatedByString(" ")
            let uid = authData[1]
            let ref = Firebase(url: "https://dailytopic-daniel.firebaseio.com/DailyTopic/Users")
            let topic = ref.childByAppendingPath(uid + "/Topic")
            let timestamp = topic.childByAutoId()
            timestamp.setValue(topicInformation)
            

        
            //Save data into the Total Topic of Firebase
           let sameTimestamp = timestamp.description().componentsSeparatedByString("/")[7]
            
           let topicRef = Firebase(url: "https://dailytopic-daniel.firebaseio.com/DailyTopic/TotalTopics/Secret")
            
           topicRef.childByAppendingPath(sameTimestamp).setValue(topicInformation)
            
            //Set the Topic Textfield equal Null
            topicTextfield.text = ""
            imageView.image = nil
        }
        else
        {
            let alert = UIAlertController(title: "Please Input a Title",
                                          message: "Add a picture ",
                                          preferredStyle: .Alert)
            
           
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .Default) { (action: UIAlertAction) -> Void in
            }
            
          
  
         
            alert.addAction(cancelAction)
            
            presentViewController(alert,
                                  animated: true,
                                  completion: nil)
        }
        
        
    }
    
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
var floatingActionButton: LiquidFloatingActionButton!
    
    
    
    override public func viewDidLoad(){
        super.viewDidLoad()
        
        PostTopicButton.layer.borderWidth = 1
        PostTopicButton.layer.cornerRadius = 5
        PostTopicButton.clipsToBounds = true
        
        
       
        //Topic Category Picker
        CategoryPicker.dataSource = self
        CategoryPicker.delegate = self
        
        
        //Picture Picture
        imagePicker.delegate = self
        topicTextfield.delegate = self
        
        //Use Goolge Folat Button
        createFloatingButtons()
        
        topicTextfield.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Input Your Daily Topic ...", comment: ""),attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
        
        topicTextfield.textColor = UIColor.redColor()
        
      
        
        
    }
    
    
    // MARK: - Create floating buttons
    
    private func createFloatingButtons()
    {
    
        cells.append(createButtonCell("Camera"))
        cells.append(createButtonCell("library"))
        
        let floatingFrame = CGRect(x: self.view.frame.width - 56 - 260,y: self.view.frame.height - 56 - 80, width: 56 , height: 56)
        let floatingButton = createButton(floatingFrame,style: .Up)
        
        self.view.addSubview(floatingButton)
        self.floatingActionButton = floatingButton
        
    }
    
    private func createButtonCell(iconName: String) -> LiquidFloatingCell
    {
        return LiquidFloatingCell(icon: UIImage(named: iconName)!)
    }
    
    private func createButton(frame: CGRect,style: LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton
    {
        let floatingActionButton = LiquidFloatingActionButton(frame: frame)
        
        floatingActionButton.animateStyle = style
        floatingActionButton.dataSource = self
        floatingActionButton.delegate = self
        
        return floatingActionButton
    }
    
    
   
    
    
    //When user finished the Input , Remove the keyboard
    public func textFieldShouldEndEditing(textField: UITextField!) -> Bool {  //delegate method
        return true
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    
    //Get the Picture form the Firebase,then change the Base 64 String into the picture
    func convertImageToBase64(image: UIImage) -> String{
        let imageData = UIImagePNGRepresentation(image)
        let base64String = imageData?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        return base64String!
    }

    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row]
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    //Selecte the Category Typr form the  picker View
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedCategoryIndex = row
    }
    
    //Test the Topic Title
    public static func canPostTopic(topicTitle:String) -> Bool {
       
        var canPost: Bool?
        
        if topicTitle == ""
        {
            canPost = false
        }
        
        if topicTitle != ""
        {
            canPost = true
        }
        
        return canPost!
    }

}



extension UIViewController: LiquidFloatingActionButtonDataSource
{
     public func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int
    {
        return cells.count
    }
    
     public func cellForIndex(index: Int) -> LiquidFloatingCell
    {
        return cells[index]
    }
}



extension UIViewController: LiquidFloatingActionButtonDelegate
{
   public func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int)
       {
        print("button number \(index) did click")
    
        if index == 0
        {
         
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        if index == 1
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            presentViewController(imagePicker, animated: true, completion: nil)
        }
        

        
    }
}




