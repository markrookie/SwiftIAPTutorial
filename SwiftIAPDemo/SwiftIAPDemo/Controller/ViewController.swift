//
//  ViewController.swift
//  SwiftIAPDemo
//
//  Created by Gou Bowen on 15/6/2.
//  Copyright (c) 2015年 M.T.F. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController {

    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var purchaseCoinButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    @IBOutlet weak var purchaseStateLabel: UILabel!
    @IBOutlet weak var coinCountLabel: UILabel!
    
    private var removeAdsProduct: SKProduct?
    private var addCoinProduct: SKProduct?
    private var coinCount = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.purchaseButton.enabled = false
        self.purchaseCoinButton.enabled = false
        self.coinCountLabel.text = "coin count: \(coinCount)"
        
        //去除广告
        RemoveAdsIAPModel.sharedInstance.startRequest("your iap id", requestProductCompletion: { (isRequestSuccess, products) -> Void in
            self.purchaseButton.enabled = isRequestSuccess
            self.removeAdsProduct = products.last as? SKProduct
        })
        //购买金币
        PurchaseCoinIAPModel.sharedInstance.startRequest("your iap id", requestProductCompletion: { (isRequestSuccess, products) -> Void in
            self.purchaseCoinButton.enabled = isRequestSuccess
            self.addCoinProduct = products.last as? SKProduct
        }) 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    @IBAction func purchasePressed(sender: UIButton) {
        RemoveAdsIAPModel.sharedInstance.purchaseProduct(self.removeAdsProduct!, success: { () -> Void in
            self.purchaseStateLabel.text = "广告已去除"
            println("purchase success")
        }) { () -> Void in
            println("purchase failed")
        }
    }
    
    @IBAction func restorePressed(sender: UIButton) {
        RemoveAdsIAPModel.sharedInstance.restorePurchase { () -> Void in
            self.purchaseStateLabel.text = "广告已去除：恢复购买"
        }
    }
    
    @IBAction func purchaseCoinPressed(sender: UIButton) {
        PurchaseCoinIAPModel.sharedInstance.purchaseProduct(self.addCoinProduct!, success: { () -> Void in
            self.coinCount += 100
            self.coinCountLabel.text = "coin count: \(self.coinCount)"
            println("purchase success")
        }) { () -> Void in
            println("purchase failed")
        }
    }
}

