//
//  MWAppBaseProjectConsts.swift
//  MWAppBase
//
//  Created by MorganWang on 8/12/2021.
//

import Foundation
import UIKit
import KeychainAccess
import SwiftyStoreKit

/// 屏幕宽度
let MWScreenWidth = UIScreen.main.bounds.size.width

/// 屏幕高度
let MWScreenHeight = UIScreen.main.bounds.size.height

// 屏幕分辨率
let MWScreenScale = UIScreen.main.scale

/// 用户界面类型
let MWInterfaceIdiom = UIDevice.current.userInterfaceIdiom

/// 存储是否同意隐私政策的 Key
let kIsAgreePrivacyPolicy = "kIsAgreePrivacyPolicy"

class MWWaterMarkProjectConsts {
    // MARK: - properties
    static let shared = MWWaterMarkProjectConsts()
    var purchaseProductID = ""
    var isPaidAdvancedFeatures = false
    let kUserIDKey = "kUserID"
    
    let keychain = Keychain(service: "")
    
    // MARK: - init
    private init() {

    }
    
    // MARK: - In-App-Purchase
    fileprivate func updatePaidValue() {
        isPaidAdvancedFeatures = getKeyChainValue(from: purchaseProductID) == "1"
    }
    
    func setupKeyChainUUID() {
        if let value = getKeyChainValue(from: kUserIDKey), value.count > 0 { // 说明已经存储过了
            return
        }
        else {
            saveToKeyChain(key: kUserIDKey, value: UUID().uuidString)
        }
    }
    
    func getKeyChainValue(from key: String) -> String? {
        let result = keychain[key]
        return result
    }
    
    func saveToKeyChain(key: String, value: String) {
        keychain[key] = value
    }
    
    fileprivate func saveBuyProductSuccess(_ productId: String) {
        // 购买成功后，存储数据到钥匙串
        saveToKeyChain(key: productId, value: "1")
    }
    
    func buyProductInfo(_ productId: String, callback: ((Bool) -> Void)?) {
        guard let userId = getKeyChainValue(from: kUserIDKey) else {
            callback?(false)
            return
        }
        
        SwiftyStoreKit.purchaseProduct(productId,
                                       quantity: 1,
                                       atomically: true,
                                       applicationUsername: userId,
                                       simulatesAskToBuyInSandbox: false) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                self.saveBuyProductSuccess(productId)
                self.updatePaidValue()
                callback?(true)
            case .error(let error):
                switch error.code {
                case .unknown:
                    print("Unknown error. Please contack support")
                case .clientInvalid:
                    print("Not allowed to make the payment")
                case .paymentCancelled:
                    print("user cancelled")
                case .paymentInvalid:
                    print("The purchase identifier was invalid")
                case .paymentNotAllowed:
                    print("The device is not allowed to make the payment")
                case .storeProductNotAvailable:
                    print("The product is not avaiable in the current storefront")
                case .cloudServicePermissionDenied:
                    print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed:
                    print("Could not connect to the network")
                case .cloudServiceRevoked:
                    print("User has revoked permission to use this cloud service")
                default:
                    print((error as NSError).localizedDescription)
                }
                callback?(false)
            default:
                callback?(false)
                break
            }
        }
    }
    
    func setupPaymentObserverQueue() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    self.saveBuyProductSuccess(purchase.productId)
                    self.updatePaidValue()
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
    }

    // MARK: - Util

    // MARK: - utils

    
    // MARK: - action
    
    
    // MARK: - other
    

}
