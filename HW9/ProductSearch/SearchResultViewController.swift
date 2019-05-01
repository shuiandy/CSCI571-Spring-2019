//
//  SearchResultViewController.swift
//  ProductSearch
//
//  Created by Shuai Hu on 4/12/19.
//  Copyright © 2019 Shuai Hu. All rights reserved.
//

import UIKit
import SwiftSpinner
import Toast_Swift
import SwiftyJSON

class SearchResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ResultTabViewCellDelegate{

    
    static var wishlistDic = [ItemData]()
    var itemList = ItemList()
    var itemRow = ItemData()
    var isWished = false
    var searchResult : JSON?
    var itemId : String?
    var itemTitle : String?
    @IBOutlet var resultTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultTable.dataSource = self
        self.resultTable.delegate = self
        if(self.itemList.isEmpty == true){
            self.resultTable.isHidden = true
            let alert = UIAlertController(title: "No Results!", message: "Failed to fetch search results", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true);
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.resultTable.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.ItemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTabViewCell", for: indexPath) as? ResultTabViewCell else{
            fatalError("Error!")
        }
        cell.delegate = self
        self.updateStoredData(paramData: self.itemList.ItemArray[indexPath.row])
        let resultRow = self.itemList.ItemArray[indexPath.row]
        let productImage = resultRow.image
        if (productImage != ""){
            let imageURL = URL(string: productImage)
            let imageData = try? Data(contentsOf: imageURL!)
            cell.productImage.image = UIImage(data: imageData!)
        } else{
            cell.productImage.image = UIImage(contentsOfFile: "")
        }
        let productTitle = resultRow.title
        let price = resultRow.price
        let shipping = resultRow.shippingcost
        let zip = resultRow.zip
        let condition = resultRow.condition
        let wishlist = resultRow.wishlist
        
        cell.productTitle.text = productTitle
        cell.price.text = "$\(price)"
        cell.shipping.text = shipping
        cell.zip.text = zip
        if(condition == "1000" || condition == "1500"){
            cell.condition.text = "NEW"
        } else if(condition == "2000" || condition == "2500"){
            cell.condition.text = "REFURBISHED"
        } else if(condition == "3000" || condition == "4000" || condition == "5000" || condition == "6000"){
            cell.condition.text = "USED"
        } else{
            cell.condition.text = "NA"
        }
        if(wishlist == true){
            cell.wishlistButton.setImage(UIImage(named: "wishListFilled"), for: .normal)
            } else{
            cell.wishlistButton.setImage(UIImage(named: "wishListEmpty"), for: .normal)
            }
        return cell
    }
    
    func ResultTabViewCellTapHeart(_sender: ResultTabViewCell) {
        guard let tappedIndex = resultTable.indexPath(for: _sender)
            else{ return };
        let data = self.itemList.ItemArray[tappedIndex.row]
        let key = self.itemList.ItemArray[tappedIndex.row].itemID
        if(_sender.isRed == true){
            data.wishlist = true
            UserDefaultsSaveObject(key: key, ItemData: data)
            self.view.makeToast("\(data.title) was added to the wishList", duration: 3.0, position: ToastPosition.bottom)
        } else{
            data.wishlist = false
            UserDefaultsRemoveObject(key: key)
            self.view.makeToast("\(data.title) was removed from wishList", duration: 3.0, position: ToastPosition.bottom)
        }
    }
    func updateStoredData(paramData:ItemData){
        if(UserDefaults.standard.array(forKey: "itemIDArr") != nil){
            let itemIDArr = UserDefaults.standard.array(forKey: "itemIDArr") as![String]
            for idStr in itemIDArr{
                if(idStr == paramData.itemID){
                    paramData.wishlist = true
                } else{
                    paramData.wishlist = false
                }
            }
        }
    }
    
    override func  prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToDetailPage"){
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.itemId = self.itemId
            destinationVC.itemDetail = itemRow
            destinationVC.itemTitle = itemTitle
            destinationVC.isRed = isWished
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = itemList.ItemArray[indexPath.row]
        itemId = cellData.itemID
        itemRow = cellData
        isWished = cellData.wishlist
        itemTitle = cellData.title
        self.performSegue(withIdentifier: "goToDetailPage", sender: self)
    }
}
