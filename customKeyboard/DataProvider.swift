//
//  DataProvider.swift
//  testKeyboard
//
//  Created by Francesco Frison on 6/17/14.
//  Copyright (c) 2014 Yammer-inc. All rights reserved.
//

import UIKit


class Friend {
    var name : String
    var imagePath : NSURL
    var image : UIImage?
    
    func cacheImage() {
        var error : NSError? = nil
        let data = NSData.dataWithContentsOfURL(self.imagePath, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &error)
        self.image = UIImage(data: data)
    }
    
    init(name: String, imagePath: String) {
        self.name = name
        self.imagePath = NSURL(string: imagePath)
        cacheImage()
    }
    
}

class DataProvider {
    
    class func friends() -> Array<Friend> {
        let url = NSURL(string: "http://dev.ziofritz.com/fb-friends.json")
        var error : NSError? = nil
        let data = NSData.dataWithContentsOfURL(url, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &error)
        let friendsAR = NSJSONSerialization.JSONObjectWithData(data , options: NSJSONReadingOptions.AllowFragments, error: &error) as Array<Dictionary<String, String>>
        
        let bkgQueue = dispatch_queue_create("com.ziofritz.bkg", DISPATCH_QUEUE_SERIAL)
        
        var friends = Array<Friend>()
        for dict in friendsAR {
            let url = NSURL(string: dict["image"]!)
            let friend = Friend(name: dict["name"]!, imagePath: dict["image"]!)
            friends.append(friend)
            
            dispatch_async(bkgQueue){
                friend.cacheImage()
            };
            
        }
        
        return friends
    }
    
}