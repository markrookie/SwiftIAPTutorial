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
    
    typealias ProductsRequestCompletionHandler = ((Bool, [AnyObject]) -> Void)
    private var requestProductCompletion: ProductsRequestCompletionHandler?

    typealias PurchaseCompletionHandler = (() -> Void)
    private var successHandler: PurchaseCompletionHandler?
    private var failedHandler: PurchaseCompletionHandler?
    private var restoredHandler: PurchaseCompletionHandler?
    
    override init() {
        super.init()
    }
    
    func startRequest(productIdentifier: String, requestProductCompletion: ProductsRequestCompletionHandler) {
        if self.isProductPurchaseAvailable() {
            var lProductIds: NSSet = NSSet(object: productIdentifier)
            var productRequest = SKProductsRequest(productIdentifiers: lProductIds as Set<NSObject>)
            productRequest.delegate = self
            productRequest.start()
            self.requestProductCompletion = requestProductCompletion
        } else {
            self.showAlert("Can't connet to itunes store", message: "")
        }
    }
    
    func purchaseProduct(product: SKProduct, success: PurchaseCompletionHandler, failed: PurchaseCompletionHandler) {
        self.showLoadingView()
        self.successHandler = success
        self.failedHandler = failed
        var payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    func restorePurchase(restore: PurchaseCompletionHandler) {
        self.showLoadingView()
        self.restoredHandler = restore
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    private func isProductPurchaseAvailable() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    private func showAlert(title: String, message: String) {
        var alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    private func showLoadingView() {
        MRProgressOverlayView.showOverlayAddedTo(UIApplication.sharedApplication().delegate?.window!, title: "Loading", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
    }
    
    private func hideLoadingView() {
        MRProgressOverlayView.dismissAllOverlaysForView(UIApplication.sharedApplication().delegate?.window!, animated: true)
    }
    
    private func completeTransaction(transaction: SKPaymentTransaction) {
        self.successHandler!()
        self.closeTransaction(transaction)
    }
    
    private func restoreTransaction(transaction: SKPaymentTransaction) {
        self.restoredHandler!()
        self.closeTransaction(transaction)
    }
    
    private func failedTransaction(transaction: SKPaymentTransaction) {
        self.failedHandler!()
        self.closeTransaction(transaction)
    }
    
    //这个非常重要如果一个交易不关闭，就会永远存在于交易队列app每次打开都会去请求交易
    private func closeTransaction(transaction: SKPaymentTransaction) {
        self.hideLoadingView()
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    // MARK: -
    // MARK: SKPaymentTransactionObserver
    // MARK: -
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        
        if let transaction = transactions.last as? SKPaymentTransaction {
            switch transaction.transactionState {
            case .Purchased:
                println("item purchased")
                self.completeTransaction(transaction)
                break
            case .Failed:
                self.failedTransaction(transaction)
                self.showAlert("Purchase Fail", message: "can not connect to ituens store")
                println("item purchase failed")
                break
            default:
                break
            }
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue!, restoreCompletedTransactionsFailedWithError error: NSError!) {
        self.showAlert("Purchase Fail", message: "can not connect to ituens store")
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
        if let transaction = queue.transactions.last as? SKPaymentTransaction {
            self.hideLoadingView()
            self.restoreTransaction(transaction)
        }
    }
    
    // MARK: -
    // MARK: SKProductsRequestDelegate
    // MARK: -
    
    func request(request: SKRequest!, didFailWithError error: NSError!) {
        self.requestProductCompletion!(false, [])
    }
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        
        var skProducts = response.products
        for skProduct in skProducts {
        }
        self.requestProductCompletion!(true,skProducts)
    }
}
