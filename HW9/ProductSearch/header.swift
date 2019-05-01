//
//  header.swift
//  ProductSearch
//
//  Created by Shuai Hu on 4/21/19.
//  Copyright © 2019 Shuai Hu. All rights reserved.
//

import UIKit


func UserDefaultsRemoveObject(key: String){
    UserDefaults.standard.removeObject(forKey: key)
    var itemIDArr = UserDefaults.standard.array(forKey: "itemIDArr") as! [String]
    itemIDArr = itemIDArr.filter{ $0 != key }
    UserDefaults.standard.set(itemIDArr, forKey: "itemIDArr")
}

func UserDefaultsSaveObject(key:String,ItemData: ItemData){
    if( UserDefaults.standard.array(forKey: "itemIDArr") == nil){
        var itemIDArr = [String]();
        itemIDArr.append(key);
        UserDefaults.standard.set(itemIDArr, forKey:"itemIDArr");
    }else{
        var itemIDArr = UserDefaults.standard.array(forKey: "itemIDArr")!;
        itemIDArr.append(key);
        UserDefaults.standard.set(itemIDArr, forKey:"itemIDArr");
    }
    let modelData = try!NSKeyedArchiver.archivedData(withRootObject: ItemData, requiringSecureCoding: false);
    UserDefaults.standard.set( modelData, forKey: key);
    
}
