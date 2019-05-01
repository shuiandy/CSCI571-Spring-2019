//
//  DetailPhotosViewController.swift
//  ProductSearch
//
//  Created by Shuai Hu on 4/16/19.
//  Copyright © 2019 Shuai Hu. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner

class DetailPhotosViewController : UIViewController, UIScrollViewDelegate {

    
    var photos : JSON?
    var itemTitle : String?
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        SwiftSpinner.show("Fetching Google Images..")
        let DetailData = tabBarController as! DetailViewController
        itemTitle = DetailData.itemTitle
        let parameter = ["title": itemTitle]
        AF.request("http://shuaihu-csci571-hw9-server.us-west-1.elasticbeanstalk.com/photos", parameters: parameter).responseJSON{
            response in
            switch response.result{
            case .success(let results):
                self.photos = JSON(results)
                if(self.photos?.count != 0){
                self.configureScrollView()
                } else{
                    let alert = UIAlertController(title: "No Results!", message: "Failed to fetch photos", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true);
                }
                SwiftSpinner.hide()
            case .failure(let failed):
                print(failed)
                let alert = UIAlertController(title: "No Results!", message: "Failed to fetch photos", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true);
                SwiftSpinner.hide()
            }
        }
        
    }

    func configureScrollView(){
        let counts = photos?.count ?? 0
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.width
            * CGFloat(counts))
        for i in 0 ..< counts{
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            let imageURL = URL(string: (photos?[i]["photo"].rawString())!)
            let imageData = try? Data(contentsOf: imageURL!)
            let Photoimage = UIImage(data: imageData!)
            imageView.image = Photoimage
            imageView.frame = CGRect(x: 0, y: view.frame.width * CGFloat(i), width: view.frame.width, height: view.frame.width)
            
            scrollView.addSubview(imageView)
        }
    }
}
