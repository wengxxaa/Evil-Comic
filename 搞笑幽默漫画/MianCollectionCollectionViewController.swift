//
//  MianCollectionCollectionViewController.swift
//  搞笑幽默漫画
//
//  Created by lu on 15/10/31.
//  Copyright © 2015年 lu. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kanna
import JGProgressHUD
import SDWebImage

private let reuseIdentifier = "Cell"


class MainCollectionViewCell: UICollectionViewCell {
    
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

class MianCollectionCollectionViewController: UICollectionViewController, UINavigationControllerDelegate {

    var populatingPhotos = false //是否在获取图片
    var currentPage = 1 //当前页数
    let refreshControl = UIRefreshControl() //下拉刷新
    var photos = NSMutableOrderedSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        

        // Do any additional setup after loading the view.
        configureRefresh()
        
        //设置视图
        setupView()
        
        //添加所有的按钮
        addBarItem()
        
        //获取第一页图片
        populatePhotos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //添加navigationitem
    func addBarItem(){
        let item = UIBarButtonItem(image: UIImage(named: "Del"), style: UIBarButtonItemStyle.Plain, target: self, action: "setting:")
        item.tintColor = UIColor.blackColor()
        
        self.navigationItem.rightBarButtonItem = item
    }
    
    func setting(sender: AnyObject){
        print("check")
    }
    //设置下拉和上啦刷新
    func configureRefresh(){
        self.collectionView?.header = MJRefreshNormalHeader(refreshingBlock: { () in
            print("header")
            self.handleRefresh()
            self.collectionView?.header.endRefreshing()
        })
        
        self.collectionView?.footer = MJRefreshAutoFooter(refreshingBlock:
            { () in
                print("footer")
                self.populatePhotos()
                self.collectionView?.footer.endRefreshing()
        })
    }

    func setupView() {
        //设置标题
//        self.navigationItem.title = self.menuView.titles[0] as String
        
        self.collectionView?.scrollsToTop = true
        let title = UILabel(frame: (self.navigationController?.navigationBar.frame)!)
        title.textColor = UIColor.blackColor()
        title.backgroundColor = UIColor.clearColor()
        title.textAlignment = NSTextAlignment.Center
        title.text = "aaa"
        title.font = UIFont(name: "Helvetica-Bold", size: CGFloat(20))
//        title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        self.navigationItem.titleView = title

//        self.navigationController?.title = "aaa"
//        self.title = "aaaa"
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()

//        self.view.addSubview(navigationBar)
        //设置flowlayout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.size.width, height: view.bounds.size.height/6)
//        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: UIApplication.sharedApplication().statusBarFrame.height)
        
        collectionView!.collectionViewLayout = layout
        collectionView!.backgroundColor = UIColor(red: 217/250, green: 218/250, blue: 223/250, alpha: 1.0)
        self.collectionView!.registerClass(MainCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    //下拉刷新回调函数
    func handleRefresh() {
        photos.removeAllObjects()
        //        清除所有图片，设置为第一页，刷新数据
        self.currentPage = 1
        self.collectionView?.reloadData()
        
        populatePhotos()//开始获取图片
    }
    
    //检查forum url，必须符合某种规则，http://www.mm131.com/qingchun/
    func checkForumUrl(forumUrl: String?)->Bool{
        if forumUrl == nil{
            return false
        }
        
        if  !forumUrl!.componentsSeparatedByString(Router.pageSource).isEmpty{
            let array = forumUrl!.componentsSeparatedByString(Router.pageSource)
            if array.count > 1 && !array[1].isEmpty{
                return true
            }
        }
        
        return false
    }
    
    //检查image url，必须符合某种规则，img1.mm131.com/pic
    func checkImageUrl(imageUrl: String?)->Bool{
        if imageUrl == nil{
            return false
        }
        
        if !imageUrl!.componentsSeparatedByString(Router.baseImageUrl).isEmpty{
            let array = imageUrl!.componentsSeparatedByString(Router.baseImageUrl)
            if array.count > 1 && !array[1].isEmpty{
                return true
            }
        }
        
        return false
    }
    
    func gb2312toutf8(data: NSData){
    
//    let enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
//    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
//    
//    return retStr;
    }
    
    //获取信息
    func populatePhotos(){
        if populatingPhotos{//正在获取，则返回
            print("return back")
            return
        }
        
        //标记正在获取，其他线程获取则返回
        populatingPhotos = true
        let pageUrl = Router.PhotoPage(currentPage).URLRequest
        Alamofire.request(.GET, pageUrl).validate().responseString{
            (request, response, result) in
            
            //
            let isSuccess = result.isSuccess
            let html = result.value
            let hud = JGProgressHUD(style: JGProgressHUDStyle.Light)
            if isSuccess == true{
                //设置等待菊花
                
                hud.textLabel.text = "加载中"
                hud.showInView(self.view, animated: true)
                hud.dismissAfterDelay(1.0, animated: true)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    //用photos保存临时数据
                    var imageUrl = [String]()
                    var forumUrl = [String]()
                    var title    = [String]()
                    //用kanna解析html数据
                    if let doc = Kanna.HTML(html: html!, encoding: NSUTF8StringEncoding){
                        CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingASCII)
                        let lastItem = self.photos.count
                        //解析imageurl
                        for node in doc.css("img"){
                            
                            if self.checkImageUrl(node["src"]){
                                let temp = node["src"]!
//                                print("imageurl: \(node["src"])")
                                imageUrl.append(temp)
                            }
                        }
                        
                        //解析forumurl
                        for node in doc.css("a"){
//                            print("forumurl: \(node["href"])")
                            if self.checkForumUrl(node["href"]){
                                if !(forumUrl.count > 0 && node["href"] == forumUrl[forumUrl.count - 1]){
//                                    print("forumurl: \(node["href"])")
                                    forumUrl.append(node["href"]!)
                                    title.append(node["title"]!)
//                                    print(node["title"]!)
                                }
                            }
                        }

                        for index in 0..<forumUrl.count {
                            let temp = EvilItem()
                            temp.imageUrl = imageUrl[index + 37]
                            temp.forumUrl = forumUrl[index]
//                            temp.title    = title[index]
                            temp.title = "邪恶漫画"
                            self.photos.addObject(temp)
                        }

                        
                        //只刷新增加的数据，不能用reloadData，会造成闪屏
                        let indexPaths = (lastItem..<self.photos.count).map { NSIndexPath(forItem: $0, inSection: 0) }
                        dispatch_async(dispatch_get_main_queue()) {
                            self.collectionView!.insertItemsAtIndexPaths(indexPaths)
                        }
                        self.currentPage++

                    }
                }
            }else{
                let hud = JGProgressHUD(style: JGProgressHUDStyle.Light)
                hud.textLabel.text = "网络有问题，请检查网络"
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                hud.showInView(self.view, animated: true)
                hud.dismissAfterDelay(1.0, animated: true)
            }
            
            //清除HUD
            hud.dismiss()
            self.populatingPhotos = false
        }
    }
    
    //点击显示大图
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let item = photos.objectAtIndex(indexPath.row) as! EvilItem
        let data = NSData(contentsOfURL: NSURL(string: item.imageUrl)!)
        let record = DbRecordItem(url: item.forumUrl, image: data!, title: item.title)
        let array = DbRecord.getInstance().getAllItems()
        if array == nil{
            DbRecord.getInstance().insertItem(record)
        }else{
            DbRecord.getInstance().updateItemByIndex(record)
        }
        
        performSegueWithIdentifier("ShowPhoto", sender: (self.photos.objectAtIndex(indexPath.item) as! EvilItem))
    }
    
    //给browser页面设置数据
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPhoto"{
            let temp = segue.destinationViewController as! ShowCollectionViewController
            temp.photoInfo = sender as! EvilItem
        }
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.collectionView?.footer.hidden = self.photos.count == 0
        return self.photos.count
    }
    
    //左右间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
    //上下间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MainCollectionViewCell
        
        let item = photos.objectAtIndex(indexPath.row) as! EvilItem
        let imageURL = NSURL(string: item.imageUrl)
        //复用时先置为nil，使其不显示原有图片
//        print(imageURL)
        cell.imageView.image = nil
        
        //用sdwebimage更加的方便，集成了cache，弃用原来的。。
        cell.imageView.sd_setImageWithURL(imageURL)
//        cell.title.text = item.title
        
        return cell
    }

}
