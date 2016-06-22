//
//  CameraViewController.swift
//  DailyTopic
//
//  Created by Daniel on 30/04/2016.
//  Copyright © 2016 Daniel. All rights reserved.
//

/**
    Youtube:Code Hangout 23: Create Video Background Screen - iOS Development Tutorial with Swift
    https://www.youtube.com/watch?v=dIoLsD9kBJ0&index=22&list=PLHmNdpdzx21Fk3YmGzDZ_12XuXj5p9Vm7
**/

import UIKit

class CameraViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var imagePicked: UIImageView!
    
    override func viewDidLoad() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
