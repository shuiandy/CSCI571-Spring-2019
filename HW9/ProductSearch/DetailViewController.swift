//
//  DetailViewController.swift
//  ProductSearch
//
//  Created by Shuai Hu on 4/14/19.
//  Copyright © 2019 Shuai Hu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Toast_Swift

class DetailViewController: UITabBarController {
    @IBOutlet weak var wishListButton: UIBarButtonItem!
    @IBOutlet weak var FacebookButton: UIBarButtonItem!
    var itemId : String?
    var itemDetail = ItemData()
    static var itemDetailTemp = ItemData()
    var itemTitle : String?
    var isRed = false
    
    let wishlistEmpty = UIImage(named: "wishListEmpty")
    let wishlist = UIImage(named: "wishListFilled")
    override func viewDidLoad() {
        super.viewDidLoad()
        DetailViewController.itemDetailTemp = itemDetail
        if(isRed == false){
            wishListButton.image = UIImage(named: "wishListEmpty")
        } else{
            wishListButton.image = UIImage(named: "wishListFilled")
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func FacebookButtonPressed(_ sender: Any) {
        var allowed = CharacterSet.urlQueryAllowed
        allowed.insert(charactersIn: "%")
        let urlTitle = itemTitle!.replacingOccurrences(of: "&", with: "%26")
        let links = "hashtag=#CSCI571Spring2019Ebay&quote=Buy \(urlTitle) for $\(itemDetail.price) from Ebay!&u=\(itemDetail.link)"
        let fbURL = "https://www.facebook.com/sharer/sharer?"
        let fbRawLink = "\(fbURL)\(links)"
        let fbLink = fbRawLink.addingPercentEncoding( withAllowedCharacters: allowed)!
        UIApplication.shared.open(URL(string: fbLink)!, options: [:], completionHandler: nil)
    }
    @IBAction func wishListButtonPressed(_ sender: Any) {
        isRed = !isRed
        let key = self.itemDetail.itemID
        if(isRed == true){
            UserDefaultsSaveObject(key: key, ItemData: self.itemDetail)
            self.wishListButton.image = UIImage(named: "wishListFilled")
            
            self.view.makeToast("\(itemDetail.title) was added to the wishList", duration: 3.0, position: ToastPosition.bottom)
           
        } else{
            UserDefaultsRemoveObject(key: key)
            self.wishListButton.image = UIImage(named: "wishListEmpty")
            self.view.makeToast("\(itemDetail.title) was removed from wishList", duration: 3.0, position: ToastPosition.bottom)
        }
    }
}
