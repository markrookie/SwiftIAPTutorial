//
//  ViewController.swift
//  SwiftIAPDemo
//
//  Created by Gou Bowen on 15/6/2.
//  Copyright (c) 2015年 M.T.F. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var purchaseCoinButton: UIButton!
    
    @IBOutlet weak var purchaseStateLabel: UILabel!
    @IBOutlet weak var coinCountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func purchasePressed(sender: UIButton) {
        println("purchase item pressed")
    }
    
    
    @IBAction func purchaseCoinPressed(sender: UIButton) {
        println("purchase coin pressed")
    }
}

