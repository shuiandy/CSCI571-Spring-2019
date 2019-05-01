//
//  SimilarItemCell.swift
//  ProductSearch
//
//  Created by Shuai Hu on 4/17/19.
//  Copyright © 2019 Shuai Hu. All rights reserved.
//

import UIKit

class SimilarItemCell: UICollectionViewCell{
    var similarItemURL : String?
    @IBOutlet weak var images: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var shippingcost: UILabel!
    @IBOutlet weak var daysleft: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBAction func CellPressed(_ sender: UIButton) {
         UIApplication.shared.open(URL(string: similarItemURL!)!, options: [:], completionHandler: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
