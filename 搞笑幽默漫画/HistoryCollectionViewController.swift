//
//  HistoryCollectionViewController.swift
//  搞笑幽默漫画
//
//  Created by lu on 15/11/8.
//  Copyright © 2015年 lu. All rights reserved.
//

import Foundation
import UIKit
private let reuseIdentifier = "Cell"
class HisCollectionViewCell: UICollectionViewCell {
    
    //image是直接连接到storyboard上的
    var imageView = UIImageView()
    var title     = UILabel()
    var panel     = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        panel.frame = bounds
        panel.backgroundColor = UIColor.whiteColor()
        addSubview(panel)
        
        addSubview(imageView)
        imageView.frame = CGRect(x: 5, y: 5, width: (self.bounds.height - 10)/140*190, height: self.bounds.height - 10)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        title.frame = CGRect(x: self.frame.width/2, y: self.frame.height/2 - 10, width: self.frame.width/2, height: 20)
        title.text = "邪恶漫画"
        addSubview(title)
    }
}
class HistoryCollectionViewController: UICollectionViewController {
    var recordItem: DbRecordItem?
    
    override func viewDidLoad() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.size.width, height: view.bounds.size.height/6)
        //        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: UIApplication.sharedApplication().statusBarFrame.height)
        
        collectionView!.collectionViewLayout = layout
//        collectionView!.backgroundColor = UIColor(red: 217/250, green: 218/250, blue: 223/250, alpha: 1.0)
        collectionView?.backgroundColor = UIColor.backColor()
        self.collectionView!.registerClass(HisCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        let item = getRecord()
        if item != nil{
            self.recordItem = DbRecordItem(url: item!.forumUrl, image: item!.imageData, title: item!.title)
        }
        self.collectionView!.reloadData()
    }
    
    func getRecord()-> DbRecordItem?{
        let record = DbRecord.getInstance().getAllItems()
        if record != nil{
            let item = record?.objectAtIndex(0) as! DbRecordItem
            return item
        }
        
        return nil
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if recordItem == nil{
            return 0
        }else{
            return 1
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowDetail", sender: recordItem)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! HisCollectionViewCell
        cell.imageView.image = UIImage(data: recordItem!.imageData)
        cell.title.text = recordItem!.title
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail"{
            let dest = segue.destinationViewController as! ShowCollectionViewController
            let data = sender as!DbRecordItem
            let photoInfo = EvilItem(forumUrl: data.forumUrl, imageUrl: nil, title: data.title)
            dest.photoInfo = photoInfo
        }
    }
}
