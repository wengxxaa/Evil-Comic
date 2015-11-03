//
//  HistoryTableViewController.swift
//  搞笑幽默漫画
//
//  Created by lu on 15/10/31.
//  Copyright © 2015年 lu. All rights reserved.
//

import UIKit


private let reuseIdentifier = "Cell"


class HisTableViewCell: UITableViewCell {
    
    //image是直接连接到storyboard上的
    var myImageView = UIImageView()
    var title     = UILabel()
    var panel     = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("coder")
        panel.frame = frame
        panel.backgroundColor = UIColor.whiteColor()
        addSubview(panel)
        print("frame = \(frame)")
        print("bounds = \(bounds)")
        addSubview(myImageView)
        myImageView.frame = CGRect(x: 5, y: 5, width: (self.frame.height - 10)/140*190, height: self.frame.height - 10)
        myImageView.contentMode = UIViewContentMode.ScaleAspectFit
        print("imageview = \(myImageView)")
        title.frame = CGRect(x: self.frame.width/2, y: self.frame.height/2 - 10, width: self.frame.width/2, height: 20)
        title.text = "邪恶漫画"
        addSubview(title)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        panel.frame = bounds
        panel.backgroundColor = UIColor.whiteColor()
        addSubview(panel)
        print("frame = \(frame)")
        print("bounds = \(bounds)")
        addSubview(myImageView)
        myImageView.frame = CGRect(x: 5, y: 5, width: (self.bounds.height - 10)/140*190, height: self.bounds.height - 10)
        myImageView.contentMode = UIViewContentMode.ScaleAspectFit
        print("imageview = \(myImageView)")
        title.frame = CGRect(x: self.bounds.width/2, y: self.bounds.height/2 - 10, width: self.bounds.width/2, height: 20)
        title.text = "邪恶漫画"
        addSubview(title)
    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        panel.frame = bounds
//        panel.backgroundColor = UIColor.whiteColor()
//        addSubview(panel)
//        
//        addSubview(imageView)
//        imageView.frame = CGRect(x: 5, y: 5, width: (self.bounds.height - 10)/140*190, height: self.bounds.height - 10)
//        imageView.contentMode = UIViewContentMode.ScaleAspectFit
//        title.frame = CGRect(x: self.frame.width/2, y: self.frame.height/2 - 10, width: self.frame.width/2, height: 20)
//        title.text = "邪恶漫画"
//        addSubview(title)
//    }
}

class HistoryTableViewController: UITableViewController {
    var recordItem: DbRecordItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(HisTableViewCell.classForCoder(), forCellReuseIdentifier: reuseIdentifier)
//        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        let item = getRecord()
//        if item != nil{
//            self.recordItem = DbRecordItem(url: item!.forumUrl, image: item!.imageData, title: item!.title)
//        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        let item = getRecord()
        if item != nil{
            self.recordItem = DbRecordItem(url: item!.forumUrl, image: item!.imageData, title: item!.title)
        }
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if recordItem == nil{
            return 0
        }else{
            return 1
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height/3
    }
    
    
    func getRecord()-> DbRecordItem?{
        let record = DbRecord.getInstance().getAllItems()
        if record != nil{
            let item = record?.objectAtIndex(0) as! DbRecordItem
            return item
        }
        
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! HisTableViewCell

        cell.imageView?.image = UIImage(data: recordItem!.imageData)
        cell.title.text = recordItem!.title
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
