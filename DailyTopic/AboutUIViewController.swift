//
//  AboutUIViewController.swift
//  DailyTopic
//
//  Created by Daniel on 5/06/2016.
//  Copyright © 2016 Daniel. All rights reserved.
//

import UIKit

class AboutUIViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backToLoginButton: UIBarButtonItem!
    
    var allOpenSourceLibraries = [OpenSourceLibrary]()
    
    @IBAction func backToLoginButtonAction(sender: AnyObject) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Initial the Oper Source library
    required init?(coder aDecoder:NSCoder){
        super.init(coder:aDecoder)
        
        let o1 = OpenSourceLibrary(newName: "NVActivityIndicatorView", newLicence: "The MIT License (MIT)\r\r Copyright (c) 2015 Nguyen Vinh @ninjaprox", newUrl: "https://github.com/ninjaprox/NVActivityIndicatorView\r\r")
        
        let o2 = OpenSourceLibrary(newName: "Firebase", newLicence: "The MIT License (MIT)\r\r Copyright © 2014 Firebase", newUrl: "https://www.firebase.com/")
        
        let o3 = OpenSourceLibrary(newName: "LiquidFloatingActionButton", newLicence: "LiquidFloatingActionButton is available under the MIT license. See the LICENSE file for more info.", newUrl: "https://github.com/yoavlt/LiquidFloatingActionButton")
        
        let o4 = OpenSourceLibrary(newName: "Lanuch Picture", newLicence: "flicker", newUrl: "https://www.flickr.com/photos/30963075@N00/5113950733/in/photolist-8MUkon-7VobKg-7TcjxE-qYXWbr-5B8qNP-pXgJF9-8woEnu-6ammJd-bfoxse-5bGr8o-4v3FSN-awFY8T-dtuA3S-jMZjfU-7ahNeq-5wDSyJ-5MQJG7-6erUsu-4VRAtG-5Aizk1-eh15Ey-4HycYw-6auVzt-q893rq-5T9WEo-67vxKK-jMXNSr-8YwrXD-5FLGeb-qGwLUp-5VkDHN-56GBvT-5HAHmD-5y2UVC-5bMjPZ-5uuh3j-2WBCsW-5b7f4s-5z6ryy-5uv61N-kpHpPV-awJFq5-6MxpZn-5xT96q-58XBDZ-9ZaERg-3WLBES-drBbkZ-7QY5XD-7PsCia")
        
        let o5 = OpenSourceLibrary(newName: "Login BackGround Video", newLicence: "Youtube:Google - Year In Search 2015", newUrl: "https://www.youtube.com/watch?v=q7o7R5BgWDY")
        
        allOpenSourceLibraries.append(o1)
        allOpenSourceLibraries.append(o2)
        allOpenSourceLibraries.append(o3)
        allOpenSourceLibraries.append(o4)
        allOpenSourceLibraries.append(o5)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allOpenSourceLibraries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cellIdentifier = "OpenSourceLibraryCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,forIndexPath: indexPath) as! OpenSourceLibraryCell
        
        //MARK: Configure the Cell...
        let o: OpenSourceLibrary = self.allOpenSourceLibraries[indexPath.row]
        cell.nameLabel.text = "name: \(o.name!)"
        cell.licenceLabel.text = "Licence: \(o.licence!)"
        cell.urlLabel.text = "URL: \(o.url!)"
        return cell
    }
    
    
    
    
}
