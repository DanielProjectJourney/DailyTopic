//
//  SearchViewController.swift
//  DailyTopic
//
//  Created by Daniel on 4/05/2016.
//  Copyright © 2016 Daniel. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource{
    
    //CollectionView Embeddid into the SearchViewController
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Search bar
    @IBOutlet weak var SearchBar: UISearchBar!
    
    //Create Topic Category Array
    var categoryArray = ["Game","Music","University Life","Food","Car","Celebrity","Tech","Sport"]
    
    //Save the Topic Category Title and Picture
    var allCategory = [TopicCategory]()
    var collectionViewLayout: UICollectionViewLayout?
    
    
    /**
     Add the Topic Type Category
    **/
    required init?(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)
        
        let c1 = TopicCategory(newTitle: "Game", newPicture: UIImage(named: "Game")!)
        let c2 = TopicCategory(newTitle: "Music",newPicture: UIImage(named: "Music")!)
        let c3 = TopicCategory(newTitle: "University Life", newPicture:UIImage(named: "University")!)
        let c4 = TopicCategory(newTitle: "Food", newPicture:UIImage(named:"Food" )!)
        let c5 = TopicCategory(newTitle: "Car", newPicture:UIImage(named:"Car")!)
        let c6 = TopicCategory(newTitle: "Celebrity", newPicture:UIImage(named:"Celebrity")!)
        let c7 = TopicCategory(newTitle: "Tech", newPicture: UIImage(named:"Tech")!)
        let c8 = TopicCategory(newTitle: "Sport", newPicture: UIImage(named: "Sport")!)
    
        allCategory.append(c1)
        allCategory.append(c2)
        allCategory.append(c3)
        allCategory.append(c4)
        allCategory.append(c5)
        allCategory.append(c6)
        allCategory.append(c7)
        allCategory.append(c8)
    }
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        //Seach Bar Function
        SearchBar.delegate = self
        self.SearchBar.endEditing(true)
        
        //Add the Search Bar View
        for subView in self.SearchBar.subviews
        {
            for subsubView in subView.subviews
            {
                if let textField = subsubView as? UITextField
                {
                    textField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Search Your Interesting Topics", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
                    //Set Search Bar Text Red Color
                    textField.textColor = UIColor.redColor()
                }
            }
        }
    }
    
    /**
     One Search Section for collection View
    **/
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /**
     The number of items in Collection View
    **/
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return categoryArray.count
    }
    
    /**
        The Collection Cell Identifier
    **/
    private struct Storyboard{
        static let CellIdentifier = "TopicCategoryCell"
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.CellIdentifier, forIndexPath: indexPath) as! TopicCategoryCollectionViewCell
        let tc:TopicCategory = self.allCategory[indexPath.row] as! TopicCategory
        cell.TopicCategoryImageView.image = tc.picture!
        cell.TopicCategoryTitleLabel.text = tc.title!
        return cell
    }
    
    
    /**
        Collection cell did selecte item driven listening
    **/
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("SearchSegue", sender: self)
    }
    
    
    /**
        Transmit the data into SearchResultViewController
    **/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SearchSegue"
        {
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
            let indexPath = indexPaths[0] as NSIndexPath
            let controller = segue.destinationViewController as! SearchResultViewController
            
            controller.topicCategory = self.allCategory[indexPath.row].title!
        
        }
        
    }
    
    
    
    
    
    
    
    
    
    //When the User Finished input ,the Keyboard will be hide
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        return true
    }
    
 
    func searchBarShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

