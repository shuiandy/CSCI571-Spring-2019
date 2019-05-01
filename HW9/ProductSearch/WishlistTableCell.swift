//
//  WishlistTableCell.swift
//  ProductSearch
//
//  Created by Shuai Hu on 4/17/19.
//  Copyright © 2019 Shuai Hu. All rights reserved.
//

import Foundation
import UIKit

class WishlistTableCell: UITableViewCell{
    
    @IBOutlet weak var WLImage: UIImageView!
    @IBOutlet weak var WLTitle: UILabel!
    @IBOutlet weak var WLPrice: UILabel!
    @IBOutlet weak var WLShipping: UILabel!
    @IBOutlet weak var WLZip: UILabel!
    @IBOutlet weak var WLCondition: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
