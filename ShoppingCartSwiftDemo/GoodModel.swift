//
//  GoodModel.swift
//  ShoppingCartSwiftDemo
//
//  Created by langyue on 15/12/16.
//  Copyright © 2015年 langyue. All rights reserved.
//

import UIKit

class GoodModel: NSObject {
    
    
    var alreadyAddShoppingCart : Bool = false
    
    var iconName : String?
    
    var title : String?
    
    var desc : String?
    
    var count : Int = 1
    
    var newPrice : String?
    
    var oldPrice : String?
    
    var selected : Bool = true
    
    init(dict: [String : AnyObject]) {
        super.init()
        //使用kvo为当前对象属性设置值
        setValuesForKeysWithDictionary(dict)
    }
    // 防止对象属性和kvc时的dict的key不匹配而崩溃
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    

}
