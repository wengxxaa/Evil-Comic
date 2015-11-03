//
//  DbRecord.swift
//  ToDo List
//
//  Created by lu on 15/10/17.
//  Copyright © 2015年 lu. All rights reserved.
//

import UIKit
import SQLite

class DbRecordItem: NSObject {
    //存放图片信息的类
    var forumUrl: String
    var imageData: NSData
    var title: String?
    
    init(url: String, image: NSData, title: String?) {
        self.forumUrl = url
        self.imageData = image
        self.title = title
    }
}

class DbRecord: NSObject {
    let id = Expression<Int64>("id")
    let url = Expression<String>("url")
    let image = Expression<NSData>("image")
    let title = Expression<String?>("title")
    let items = Table("items")
    var db: Connection?
    static var defaultManager: DbRecord?
    
    override init() {
        super.init()
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first!
        do{
            db = try Connection("\(path)/db.sqlite3")
        }catch{
            print("init db failed")
        }
        
        do{
            try db!.run(items.create(ifNotExists: true) { t in     // CREATE TABLE "users" (
                t.column(id, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
                t.column(url)  //     "email" TEXT UNIQUE NOT NULL,
                t.column(image)                 //     "name" TEXT
                t.column(title)
                })
        }catch{
            print("init table failed")
        }
    }
    
    static func getInstance()->DbRecord{
        if (self.defaultManager == nil){
            self.defaultManager = DbRecord()
        }
        
        return self.defaultManager!
    }
    
    func getAllItems()-> NSMutableArray?{
        var array: NSMutableArray?
        var temp: DbRecordItem?
        for item in db!.prepare(items){
            if array == nil{
                array = NSMutableArray()
            }
            temp = DbRecordItem(url: item[url], image: item[image], title: item[title])
            array!.addObject(temp!)
        }
        
        return array
    }
    
    func updateItemByIndex(item: DbRecordItem){
        let oldItem = items.filter(id == 1)
        do{
            try db?.run(oldItem.update(url <- item.forumUrl, image <- item.imageData, title <- item.title))
        }catch{
            print("update item failed")
        }
    }
    
    func insertItem(item: DbRecordItem) -> Int64{
        var rowid: Int64 = -1
        let insert = items.insert(url <- item.forumUrl, image <- item.imageData, title <- item.title)
        do{
            rowid = try db!.run(insert)
        }catch{
            print("insert failed")
        }
        
        return rowid
    }
    
    func deleteItemByIndex(index: Int64) -> Bool{
        let item = items.filter(id == index)
        do{
            try db!.run(item.delete())
        }catch{
            print("delete item failed")
            return false
        }
        
        return true
    }
}





