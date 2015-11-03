//
//  DevilItem.swift
//  搞笑幽默漫画
//
//  Created by lu on 15/10/31.
//  Copyright © 2015年 lu. All rights reserved.
//

import UIKit

class EvilItem: NSObject {
    //存放图片信息的类
    var forumUrl: String = ""
    var imageUrl: String = ""
    var title: String    = ""
}

enum Router {//必须实现URLRequestConvertible
    static let baseURLString: String = "http://www.27270.com/game/xieemanhua/list_19_"
    static let baseImageUrl = "http://t1.27270.com/uploads/"
    static let pageSource = "http://www.27270.com/game/xieemanhua/"
    case PhotoPage(Int)
    
    //这里组装要请求的网页地址
    var URLRequest: String{
        var url: String
        
        switch self{
        case .PhotoPage(let page):
            url = Router.baseURLString + "\(page).html"
        }
        
        return url
    }
    
    //组装每个类型的图片基本地址
//    var pageSource: String{
//        return "http://t1.27270.com/uploads/tu/"
//    }
}