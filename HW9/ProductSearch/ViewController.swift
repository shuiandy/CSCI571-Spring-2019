//
//  ViewController.swift
//  ProductSearch
//
//  Created by Shuai Hu on 4/10/19.
//  Copyright © 2019 Shuai Hu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    @IBAction func tabChanged(_ sender: UISegmentedControl) {
        switch segmentController.selectedSegmentIndex
        {
        case 0:
            SearchTabView.isHidden = false
            WishListTabView.isHidden = true
        case 1:
            SearchTabView.isHidden = true
            WishListTabView.isHidden = false
        default:
            break;
        }
    }
    @IBOutlet weak var SearchTabView: UIView!
    @IBOutlet weak var WishListTabView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchTabView.isHidden = false
        WishListTabView.isHidden = true
        // Do any additional setup after loading the view.
    }


}

