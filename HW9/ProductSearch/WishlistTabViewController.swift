//
//  WishlistTabViewController.swift
//  ProductSearch
//
//  Created by Shuai Hu on 4/11/19.
//  Copyright © 2019 Shuai Hu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class WishlistTabViewController : UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var WishlistTableView: UITableView!
    @IBOutlet weak var WLCount: UILabel!
    @IBOutlet weak var WLTotalPrice: UILabel!
    @IBOutlet weak var NoResults: UILabel!
    var WishlistDic = [ItemData]()
    var selectedRow = 0
    var itemId : String?
    var itemTitle : String?
    var itemRow = ItemData()
    
    override func viewDidAppear(_ animated: Bool) {
        WishlistTableView.dataSource = self
        WishlistTableView.delegate = self
        self.readWishlist()
        refeshCount()
        WishlistTableView.reloadData()
        
    }
    func readWishlist(){
        self.WishlistDic.removeAll()
        let dic = UserDefaults.standard.dictionaryRepresentation()
        if( UserDefaults.standard.array(forKey: "itemIDArr") != nil && UserDefaults.standard.array(forKey: "itemIDArr")!.count != 0){
            let itemIDArr = UserDefaults.standard.array(forKey: "itemIDArr") as![String]
            for index in itemIDArr{
                for key in dic.keys{
                    if (index == key){
                        let nsData = UserDefaults.standard.data(forKey: key)
                        let itemData = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(nsData!) as? ItemData)!
                        self.WishlistDic.append(itemData)
                        
                    }
                }
            }
            self.NoResults.isHidden = true
            self.WLTotalPrice.isHidden = false
            self.WLCount.isHidden = false
            self.WishlistTableView.isHidden = false
        } else{
            self.NoResults.isHidden = false
            self.WLTotalPrice.isHidden = true
            self.WLCount.isHidden = true
            self.WishlistTableView.isHidden = true
        }
        refeshCount()
    }
    func refeshCount(){
        var totalPrice = 0.00
        if(WishlistDic.count == 1){
            WLCount.text = "WishList Total(\(WishlistDic.count) item):"
        } else {
            WLCount.text = "WishList Total(\(WishlistDic.count) items):"
        }
        for item in WishlistDic{
            totalPrice += Double(item.price)!
        }
        WLTotalPrice.text = "$\(String(totalPrice))"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WishlistDic.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150.0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "wishlistTableCell", for: indexPath) as? WishlistTableCell else{
            fatalError("Error")
        }
        let dataList = WishlistDic[indexPath.row]
        let condition = dataList.condition
        let imageURL = URL(string: dataList.image)
        let imageData = try? Data(contentsOf: imageURL!)
        cell.WLImage.image = UIImage(data: imageData!)
        cell.WLTitle.text = dataList.title
        cell.WLPrice.text = "$\(dataList.price)"
        cell.WLZip.text = dataList.zip
        cell.WLShipping.text = dataList.shippingcost
        if(condition == "1000"){
            cell.WLCondition.text = "NEW"
        } else if(condition == "2000" || condition == "2500"){
            cell.WLCondition.text = "REFURBISHED"
        } else if(condition == "3000" || condition == "5000" || condition == "6000"){
            cell.WLCondition.text = "USED"
        } else{
            cell.WLCondition.text = "NA"
        }

        return cell
    }
    override func  prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DetailViewController {
            destinationVC.itemId = self.itemId
            destinationVC.itemDetail = self.WishlistDic[self.selectedRow]
            destinationVC.itemTitle = itemTitle
            destinationVC.isRed = true
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = WishlistDic[indexPath.row]
        itemId = cellData.itemID
        itemRow = cellData
        itemTitle = cellData.title
        self.performSegue(withIdentifier: "wishlistToDetail", sender: self);
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete";
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            UserDefaultsRemoveObject(key: self.WishlistDic[indexPath.row].itemID)
            self.WishlistDic.remove(at: indexPath.row)
            refeshCount()
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            WishlistTableView.reloadData()
            if(self.WishlistDic.count == 0){
                self.NoResults.isHidden = false
                self.WishlistTableView.isHidden = true
                self.WLCount.isHidden = true
                self.WLTotalPrice.isHidden = true
            }
        }
    }
}

    
    

