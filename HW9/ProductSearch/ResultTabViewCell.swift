//
//  ResultTabViewCell.swift
//  ProductSearch
//
//  Created by Shuai Hu on 4/13/19.
//  Copyright © 2019 Shuai Hu. All rights reserved.
//

import UIKit

protocol ResultTabViewCellDelegate: class {
    func ResultTabViewCellTapHeart( _sender: ResultTabViewCell );
}

class ResultTabViewCell : UITableViewCell {
    var rowIndex : Int = 0
    var clicked : Int = 0
    var isRed = false
    weak var delegate: ResultTabViewCellDelegate?
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var shipping: UILabel!
    @IBOutlet weak var zip: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var wishlistButton: UIButton!
    let wishlistEmpty = UIImage(named: "wishListEmpty")
    let wishlist = UIImage(named: "wishListFilled")
    @IBAction func wishListButtonPressed(_ sender: Any) {
        isRed = !isRed
        if(isRed == true){
            self.wishlistButton.setImage(wishlist, for: .normal)
        } else{
            self.wishlistButton.setImage(wishlistEmpty, for: .normal)
        }
        delegate?.ResultTabViewCellTapHeart(_sender: self);
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
