//
//  IAPModel.swift
//  SwiftIAPDemo
//
//  Created by Gou Bowen on 15/6/2.
//  Copyright (c) 2015年 M.T.F. All rights reserved.
//

import StoreKit

class IAPModel: NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    var productId = ""
    
    typealias ProductsRequestCompletionHandler = () -> Void
    
    class var sharedInstance: IAPModel {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: IAPModel? = nil
        }
        dispatch_once(&Static.onceToken, { () -> Void in
            Static.instance = IAPModel()
        })
        return Static.instance!
    }
    
    override init() {
        super.init()
    }
    
    
    func startRequest(productIdentifier: String, completionHandler: ProductsRequestCompletionHandler) {
        if self.isProductPurchaseAvailable() {
            
        }
    }
    
    func startRequestWithProductIdentifier(productIdentifier: String) {
        self.productId = productIdentifier
    }
    
    func requestProductCompletion(completionHandler: ProductsRequestCompletionHandler) {
        
    }
    
    private func isProductPurchaseAvailable() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    // MARK: -
    // MARK: SKPaymentTransactionObserver
    // MARK: -
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        
        if let transaction = transactions.last as? SKPaymentTransaction {
            switch transaction.transactionState {
            case .Purchased:
                println("item purchased")
                break
            case .Failed:
                println("item purchase failed")
                break
            default:
                break
            }
        }
    }
    
    // MARK: -
    // MARK: SKProductsRequestDelegate
    // MARK: -
    
    func request(request: SKRequest!, didFailWithError error: NSError!) {
        
    }
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        
    }
}
