//
//  DetailSimilarViewController.swift
//  ProductSearch
//
//  Created by Shuai Hu on 4/15/19.
//  Copyright © 2019 Shuai Hu. All rights reserved.
//

import SwiftyJSON
import Alamofire
import SwiftSpinner

class DetailSimilarViewController : UIViewController, UICollectionViewDataSource, UIScrollViewDelegate{
    
    var itemId : String?
    var rawData = [SimilarData]()
    var showData = [SimilarData]()
    var jsonData : JSON?
    override func viewDidLoad() {
        super.viewDidLoad()
        SimilarCollectionView.dataSource = self
        SwiftSpinner.show("Fetching Similar Items...")
        let DetailData = tabBarController as! DetailViewController
        itemId = DetailData.itemId
        let parameter = ["id": itemId]
        AF.request("http://shuaihu-csci571-hw9-server.us-west-1.elasticbeanstalk.com/similar", parameters: parameter).responseJSON{
            response in
            switch response.result{
            case .success(let results):
                self.jsonData = JSON(results)
                if(self.jsonData?.count != 0){
                    for(_,subJson):(String, JSON) in self.jsonData!{
                        let temp = SimilarData()
                        temp.itemName = subJson["title"].rawString()!
                        temp.price = Double(subJson["price"].rawString()!)
                        temp.daysLeft = Int(subJson["time"].rawString()!)
                        temp.shippingCost = Double(subJson["cost"].rawString()!)
                        temp.itemPic = URL(string: subJson["image"].rawString()!)
                        temp.itemURL = subJson["link"].rawString()!
                        self.rawData.append(temp)
                    }
                } else {
                    let alert = UIAlertController(title: "No Results!", message: "Failed to fetch similar items", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true);
                }
                self.showData = self.rawData
                self.orderBy.isEnabled = false
                self.SimilarCollectionView.reloadData()
                SwiftSpinner.hide()
            case .failure(let failed):
                print(failed)
                let alert = UIAlertController(title: "No Results!", message: "Failed to fetch similar items", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true);
                SwiftSpinner.hide()
            }
        }
    }
    @IBOutlet weak var sortbysegment: UISegmentedControl!
    @IBOutlet weak var orderBy: UISegmentedControl!

    @IBOutlet weak var SimilarCollectionView: UICollectionView!
    
    @IBAction func sortingMethod(_ sender: Any) {
        switch sortbysegment.selectedSegmentIndex
        {
        case 0:
            orderBy.isEnabled = false
            showData = rawData

        case 1:
            orderBy.isEnabled = true
            showData.sort(by:{(Cell1:SimilarData, Cell2:SimilarData) -> Bool in
                if(orderBy.selectedSegmentIndex == 0){
                    return Cell1.itemName<Cell2.itemName
                } else{
                    return Cell1.itemName>Cell2.itemName
                }
            })
        case 2:
            orderBy.isEnabled = true
            showData.sort(by:{(Cell1:SimilarData, Cell2:SimilarData) -> Bool in
                if(orderBy.selectedSegmentIndex == 0){
                    return Cell1.price<Cell2.price
                } else{
                    return Cell1.price>Cell2.price
                }
            })
        case 3:
            orderBy.isEnabled = true
            showData.sort(by:{(Cell1:SimilarData, Cell2:SimilarData) -> Bool in
                if(orderBy.selectedSegmentIndex == 0){
                    return Cell1.daysLeft<Cell2.daysLeft
                } else{
                    return Cell1.daysLeft>Cell2.daysLeft
                }
            })
        case 4:
            orderBy.isEnabled = true
            showData.sort(by:{(Cell1:SimilarData, Cell2:SimilarData) -> Bool in
                if(orderBy.selectedSegmentIndex == 0){
                    return Cell1.shippingCost<Cell2.shippingCost
                } else{
                    return Cell1.shippingCost>Cell2.shippingCost
                }
            })
        default:
            break
        }
        SimilarCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "similarCell", for: indexPath) as! SimilarItemCell
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 12
        cell.layer.borderColor = UIColor.init(red: 0.7843, green: 0.7843, blue: 0.7843, alpha: 1.0).cgColor
        cell.contentView.layer.cornerRadius = 12
        cell.contentView.backgroundColor = UIColor.init(red: 0.9647, green: 0.9647, blue: 0.9647, alpha: 1.0)
        let cellRoot = showData[indexPath.item]
        let imageURL = cellRoot.itemPic
        let imageData = try? Data(contentsOf: imageURL!)
        cell.images.image = UIImage(data: imageData!)
        cell.itemTitle.text = cellRoot.itemName
        cell.price.text = "$\(String(cellRoot.price) )"
        cell.shippingcost.text = "$\(String(cellRoot.shippingCost) )"
        if(cellRoot.daysLeft == 0 || cellRoot.daysLeft == 1){
            cell.daysleft.text = "\(String(cellRoot.daysLeft)) day left"
        } else{
            cell.daysleft.text = "\(String(cellRoot.daysLeft)) days left"
        }
        
        cell.similarItemURL = cellRoot.itemURL
        return cell
    }
}
