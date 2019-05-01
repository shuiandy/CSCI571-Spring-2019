//
//  ItemData.swift
//  ProductSearch
//
//  Created by Shuai Hu on 4/19/19.
//  Copyright © 2019 Shuai Hu. All rights reserved.
//

import UIKit
import SwiftyJSON

class ItemData: NSObject, NSCoding{
    
    var itemID: String = ""
    var title: String = "N/A"
    var price: String = "N/A"
    var shipping: String = "N/A"
    var zip: String = "N/A"
    var condition: String = "N/A"
    var wishlist: Bool = false
    var index: String = "N/A"
    var itemId: String = "N/A"
    var image: String = "N/A"
    var link: String = "N/A"
    var returnCond: String = "N/A"
    var seller: String = "N/A"
    var shippingcost: String = "N/A"
    var shippinglocation: String = "N/A"
    var handlingtime: String = "N/A"
    var expeditedshipping: String = "N/A"
    var oneday: String = "N/A"
    var feedbackscore: String = "N/A"
    var feedbackrating: String = "N/A"
    var popularity: String = "N/A"
    var toprated: String = "N/A"
    var storename: String = "N/A"
    var buyat: String = "N/A"
    
    func unpackItemData(dataJSON: JSON){
        self.index = dataJSON["index"].stringValue
        self.itemID = dataJSON["itemId"].stringValue
        self.image = dataJSON["image"].stringValue
        self.link = dataJSON["link"].stringValue
        self.title = dataJSON["title"].stringValue
        self.price = dataJSON["price"].stringValue
        self.shipping = dataJSON["shipping"].stringValue
        self.returnCond = dataJSON["return"].stringValue
        self.zip = dataJSON["zip"].stringValue
        self.condition = dataJSON["condition"].stringValue
        self.seller = dataJSON["seller"].stringValue
        self.wishlist = dataJSON["wishlist"].boolValue
        self.shippingcost = dataJSON["shippingcost"].stringValue
        self.shippinglocation = dataJSON["shippinglocation"].stringValue
        self.handlingtime = dataJSON["handlingtime"].stringValue
        self.expeditedshipping = dataJSON["expeditedshipping"].stringValue
        self.oneday = dataJSON["oneday"].stringValue
        self.feedbackscore = dataJSON["feedbackscore"].stringValue
        self.feedbackrating = dataJSON["feedbackrating"].stringValue
        self.popularity = dataJSON["popularity"].stringValue
        self.toprated = dataJSON["toprated"].stringValue
        self.storename = dataJSON["storename"].stringValue
        self.buyat = dataJSON["buyat"].stringValue
    }
    override init(){
        super.init()
    }
    required init(coder decoder: NSCoder){
        self.index = decoder.decodeObject(forKey: "index") as? String ?? ""
        self.itemID = decoder.decodeObject(forKey: "itemId") as? String ?? ""
        self.image = decoder.decodeObject(forKey: "image") as? String ?? ""
        self.title = decoder.decodeObject(forKey: "title") as? String ?? ""
        self.price = decoder.decodeObject(forKey: "price") as? String ?? ""
        self.shipping = decoder.decodeObject(forKey: "shipping") as? String ?? ""
        self.zip = decoder.decodeObject(forKey: "zip") as? String ?? ""
        self.condition = decoder.decodeObject(forKey: "condition") as? String ?? ""
        self.wishlist = decoder.decodeObject(forKey: "wishlist") as? Bool ?? false
        self.index = decoder.decodeObject(forKey: "index") as? String ?? ""
        self.link = decoder.decodeObject(forKey: "link") as? String ?? ""
        self.returnCond = decoder.decodeObject(forKey: "return") as? String ?? ""
        self.seller = decoder.decodeObject(forKey: "seller") as? String ?? ""
        self.shippingcost = decoder.decodeObject(forKey: "shippingcost") as? String ?? ""
        self.shippinglocation = decoder.decodeObject(forKey: "shippinglocation") as? String ?? ""
        self.handlingtime = decoder.decodeObject(forKey: "handlingtime") as? String ?? ""
        self.expeditedshipping = decoder.decodeObject(forKey: "expeditedshipping") as? String ?? ""
        self.oneday = decoder.decodeObject(forKey: "oneday") as? String ?? ""
        self.feedbackscore = decoder.decodeObject(forKey: "feedbackscore") as? String ?? ""
        self.feedbackrating = decoder.decodeObject(forKey: "feedbackrating") as? String ?? ""
        self.popularity = decoder.decodeObject(forKey: "popularity") as? String ?? ""
        self.toprated = decoder.decodeObject(forKey: "toprated") as? String ?? ""
        self.storename = decoder.decodeObject(forKey: "storename") as? String ?? ""
        self.buyat = decoder.decodeObject(forKey: "buyat") as? String ?? ""

        
    }
    func encode(with coder: NSCoder) {
        coder.encode(index, forKey: "index")
        coder.encode(itemID, forKey: "itemId")
        coder.encode(image, forKey: "image")
        coder.encode(title, forKey: "title")
        coder.encode(price, forKey: "price")
        coder.encode(shipping, forKey: "shipping")
        coder.encode(zip, forKey: "zip")
        coder.encode(condition, forKey: "condition")
        coder.encode(index, forKey: "index")
        coder.encode(link, forKey: "link")
        coder.encode(returnCond, forKey: "return")
        coder.encode(seller, forKey: "seller")
        coder.encode(shippinglocation, forKey: "shippinglocation")
        coder.encode(shippingcost, forKey: "shippingcost")
        coder.encode(handlingtime, forKey: "handlingtime")
        coder.encode(expeditedshipping, forKey: "expeditedshipping")
        coder.encode(oneday, forKey: "oneday")
        coder.encode(feedbackscore, forKey: "feedbackscore")
        coder.encode(feedbackrating, forKey: "feedbackrating")
        coder.encode(popularity, forKey: "popularity")
        coder.encode(toprated, forKey: "toprated")
        coder.encode(storename, forKey: "storename")
        coder.encode(buyat, forKey: "buyat")
        coder.encode(wishlist, forKey: "wishlist")
        
    }

}

class ItemList: NSObject{
    var ItemArray = [ItemData]()
    var isEmpty = false
    
    override  init(){
        super.init()
    }
    static func unpackItemList(dataJSON: JSON) -> ItemList{
        let list = ItemList.init()
        if(dataJSON.error != nil){
            list.isEmpty = true
        } else{
        for tempItemJSON in dataJSON{
            list.isEmpty = false
            let item = ItemData.init()
            item.unpackItemData(dataJSON: tempItemJSON.1)
            list.ItemArray.append(item)
            }
        }
        return list
    }
}
