//
//  DetailInfoViewController.swift
//  ProductSearch
//
//  Created by Shuai Hu on 4/14/19.
//  Copyright © 2019 Shuai Hu. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner


class DetailInfoViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var itemId : String?
    var itemResult : JSON?
    static var itemResultTemp : JSON?
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var DescTableView: UITableView!
    @IBOutlet weak var imagesView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        DescTableView.dataSource = self
        DescTableView.delegate = self
        let DetailData = tabBarController as! DetailViewController
        itemId = DetailData.itemId
        let parameter = ["id": itemId]
        SwiftSpinner.show("Fetching Product Details...")
        AF.request("http://shuaihu-csci571-hw9-server.us-west-1.elasticbeanstalk.com/itemdetails", parameters: parameter).responseJSON{
            response in
            switch response.result{
            case .success(let results):
                self.itemResult = JSON(results)
                DetailInfoViewController.itemResultTemp = JSON(results)
                let resultRow = self.itemResult?[0]
                let itemsTitle = resultRow?["title"]
                let itemsPrice = resultRow?["price"]
                self.itemTitle.text = itemsTitle?.rawString()
                self.itemPrice.text = itemsPrice?.rawString()
                self.configurePageControl()
                self.DescTableView.reloadData()
                SwiftSpinner.hide()
            case .failure(let failed):
                print(failed)
                let alert = UIAlertController(title: "No Results!", message: "Failed to fetch item detail", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true);
                SwiftSpinner.hide()
            }
        }
    }
    func configurePageControl() {
        let InfoImage = DetailInfoViewController.itemResultTemp![0]["images"]
        self.pageControl.numberOfPages = (InfoImage.count)
        scrollView.frame = CGRect(x: 0, y: 0, width: imagesView.frame.width, height: imagesView.frame.height)
        scrollView.contentSize = CGSize(width: imagesView.frame.width * CGFloat(InfoImage.count), height: imagesView.frame.height)
        scrollView.isPagingEnabled = true
        for i in 0 ..< InfoImage.count{
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: imagesView.frame.width * CGFloat(i), y: 0, width: imagesView.frame.width, height: imagesView.frame.height)
            let imageURL = URL(string: (InfoImage[i].rawString()!))
            let imageData = try? Data(contentsOf: imageURL!)
            imageView.image = UIImage(data: imageData!)
            scrollView.addSubview(imageView)
        }
        self.pageControl.currentPage = 0
        self.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        self.view.addSubview(pageControl)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemResult?[0]["specific"]["NameValueList"].count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 30.0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "infoTabViewCell", for: indexPath) as? InfoTabViewCell else{
            fatalError("Error")
        }
        let cellRow = self.itemResult?[0]["specific"]["NameValueList"][indexPath.row]
        cell.InfoTitle.text = cellRow?["Name"].rawString()
        cell.InfoDescription.text = cellRow?["Value"][0].rawString()
        return cell
    }

}
