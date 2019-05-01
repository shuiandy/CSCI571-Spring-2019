//
//  InfoTabViewController.swift
//  ProductSearch
//
//  Created by Shuai Hu on 4/15/19.
//  Copyright © 2019 Shuai Hu. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner

class DetailShippingViewController: UIViewController {
    
    
    @IBOutlet weak var StoreNameLabel: UILabel!
    @IBOutlet weak var FeedbackScoreLabel: UILabel!
    @IBOutlet weak var PopularityLabel: UILabel!
    @IBOutlet weak var FeedbackStarLabel: UILabel!
    @IBOutlet weak var storeName: UIButton!
    @IBOutlet weak var feedbackScore: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var ShippingCostLabel: UILabel!
    @IBOutlet weak var GlobalShippingLabel: UILabel!
    @IBOutlet weak var HandlingTimeLabel: UILabel!
    @IBOutlet weak var shippingCost: UILabel!
    @IBOutlet weak var globalShipping: UILabel!
    @IBOutlet weak var handlingTime: UILabel!
    @IBOutlet weak var PolicyLabel: UILabel!
    @IBOutlet weak var RefundModeLabel: UILabel!
    @IBOutlet weak var ReturnWithinLabel: UILabel!
    @IBOutlet weak var PaidByLabel: UILabel!
    @IBOutlet weak var policy: UILabel!
    @IBOutlet weak var refundMode: UILabel!
    @IBOutlet weak var returnWithin: UILabel!
    @IBOutlet weak var paidBy: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet var SellerView: UIView!
    @IBOutlet var ShippingInfoView: UIView!
    @IBOutlet var ReturnPolicyView: UIView!

    var itemId : String?
    var buyat : String?
    var resultData = ItemData()
    var detailData : JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Fetching Shipping Data...")
        resultData = DetailViewController.itemDetailTemp
        detailData = DetailInfoViewController.itemResultTemp?[0]
        if(resultData.storename != "" ||
            resultData.feedbackscore != "" ||
        resultData.popularity != "" ||
            resultData.feedbackrating != "")
        {
        if(resultData.storename != ""){
            self.storeName.setTitle(resultData.storename,for: .normal )
        } else{
            StoreNameLabel.isHidden = true
            storeName.isHidden = true
        }
         buyat = resultData.buyat

        if(resultData.feedbackscore != ""){
        self.feedbackScore.text = resultData.feedbackscore
        } else {
            FeedbackStarLabel.isHidden = true
            feedbackScore.isHidden = true
        }
        if(resultData.popularity != ""){
        self.popularity.text = resultData.popularity
        } else {
            PopularityLabel.isHidden = true
            popularity.isHidden = true
        }
        if(resultData.feedbackrating != ""){
            if((resultData.feedbackrating.contains("Shooting"))){
                self.starImage.image = UIImage (named: "star")!.withRenderingMode(.alwaysTemplate)
                if(resultData.feedbackrating == "YellowShooting"){
                self.starImage.tintColor = UIColor.yellow
                } else if(resultData.feedbackrating == "TurquoiseShooting"){
                    self.starImage.tintColor = UIColor.init(red: 0.251, green: 0.8784, blue: 0.8157, alpha: 1.0)
                } else if(resultData.feedbackrating == "PurpleShooting"){
                    self.starImage.tintColor = UIColor.purple
                } else if(resultData.feedbackrating == "RedShooting"){
                    self.starImage.tintColor = UIColor.red
                } else if(resultData.feedbackrating == "GreenShooting"){
                    self.starImage.tintColor = UIColor.green
                } else if(resultData.feedbackrating == "SilverShooting"){
                    self.starImage.tintColor = UIColor.init(red: 0.7529, green: 0.7529, blue: 0.7529, alpha: 1.0)
                }

            } else{
                
                self.starImage.image = UIImage (named: "starBorder")!.withRenderingMode(.alwaysTemplate)
                if(resultData.feedbackrating == "None"){
                self.starImage.tintColor = UIColor.black
                }
                else if(resultData.feedbackrating == "Yellow"){
                    self.starImage.tintColor = UIColor.yellow
                }
                else if(resultData.feedbackrating == "Blue"){
                    
                    self.starImage.tintColor = UIColor.blue
                }
                else if(resultData.feedbackrating == "Turquoise"){
                    self.starImage.tintColor = UIColor.init(red: 0.251, green: 0.8784, blue: 0.8157, alpha: 1.0)
                }
                else if(resultData.feedbackrating == "Purple"){
                    self.starImage.tintColor = UIColor.purple
                }
                else if(resultData.feedbackrating == "Red"){
                    self.starImage.tintColor = UIColor.red
                }
                else if(resultData.feedbackrating == "Green"){
                    self.starImage.tintColor = UIColor.green
                }
            }

        } else{
           SellerView.isHidden = true
        }
        }
        
        if(resultData.shippingcost != "" || detailData?["globalshipping"].rawString() != "" || resultData.handlingtime != "")
        {
        if(resultData.shippingcost != ""){
            self.shippingCost.text = resultData.shippingcost == "FREE SHIPPING" ? "FREE" : resultData.shippingcost
        }else{
            ShippingCostLabel.isHidden = true
            shippingCost.isHidden = true
        }
        if(detailData?["globalshipping"].rawString() != ""){
            self.globalShipping.text = (detailData?["globalshipping"].rawString() == "true") ? "Yes" : "No"
        } else{
            GlobalShippingLabel.isHidden = true
            GlobalShippingLabel.isHidden = true
        }
        if(resultData.handlingtime != ""){
            if(resultData.handlingtime == "0"){
                self.handlingTime.text = "0 day"
            }
            else if(resultData.handlingtime == "1"){
                self.handlingTime.text = "1 day"
            } else {
                self.handlingTime.text = "\(resultData.handlingtime) days"
            }
        } else {
            HandlingTimeLabel.isHidden = true
            handlingTime.isHidden = true
            }
        } else {
            ShippingInfoView.isHidden = true
        }
        
        if(resultData.returnCond != "" || detailData?["refund"].rawString() != "" || detailData?["returnswithin"].rawString() != "" || detailData?["paidby"].rawString() != "")
        {
        if(resultData.returnCond != ""){
            self.policy.text = (resultData.returnCond == "true") ? "Returns Accepted" : "Returns Not Accepted"
        } else{
            PolicyLabel.isHidden = true
            policy.isHidden = true
        }
        if(detailData?["refund"].rawString() != ""){
        self.refundMode.text = detailData?["refund"].rawString()
        } else{
            RefundModeLabel.isHidden = true
            refundMode.isHidden = true
        }
        if(detailData?["returnswithin"].rawString() != ""){
        self.returnWithin.text = detailData?["returnswithin"].rawString()
        } else{
            ReturnWithinLabel.isHidden = true
            returnWithin.isHidden = true
        }
        if(detailData?["paidby"].rawString() != ""){
        self.paidBy.text = detailData?["paidby"].rawString()
        } else {
            PaidByLabel.isHidden = true
            paidBy.isHidden = true
            }
        } else {
            ReturnPolicyView.isHidden = true
        }
        SwiftSpinner.hide()
    }
    @IBAction func storeNamePressed(_ sender: UIButton) {
        self.openUrl(url: buyat)
    }
    func openUrl(url:String!) {
        let targetURL=NSURL(string: url)
        
        let application=UIApplication.shared
        
        application.open(targetURL! as URL, options: [:], completionHandler: nil);
        
    }
    func drawLine(startX: Int, toEndingX endX: Int, startingY startY: Int, toEndingY endY: Int, ofColor lineColor: UIColor, widthOfLine lineWidth: CGFloat, inView view: UIView) {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: endX, y: endY))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        
        view.layer.addSublayer(shapeLayer)
        
    }
}
