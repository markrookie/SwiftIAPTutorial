//
//  RemoveAdsIAPModel.swift
//  SwiftIAPDemo
//
//  Created by Gou Bowen on 15/6/3.
//  Copyright (c) 2015年 M.T.F. All rights reserved.
//

class RemoveAdsIAPModel: IAPModel {
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
}