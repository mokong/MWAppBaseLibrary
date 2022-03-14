//
//  MWAppBaseProjectConsts.swift
//  MWAppBase
//
//  Created by MorganWang on 8/12/2021.
//

import Foundation
import UIKit
import AVFoundation
import ZLPhotoBrowser
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


/// 拍照水印最大宽度
let kWaterMarkMaxWidth: CGFloat = MWScreenWidth / 5.0 * 4.0
let kNormalWaterMarkMaxWidth: CGFloat = MWScreenWidth - 54.0

/// 拖拽 Point String
let kMarkDragPositionKey: String = "kMarkDragPositionKey"

/// 存储是否同意隐私政策的 Key
let kIsAgreePrivacyPolicy = "kIsAgreePrivacyPolicy"

/// 是否显示水印时间
let kIsWatermarkTimeOnKey = "kIsWatermarkTimeOnKey"

/// 是否显示水印日期
let kIsWatermarkDateOnKey = "kIsWatermarkDateOnKey"

/// 是否显示水印位置
let kIsWatermarkLocationOnKey = "kIsWatermarkLocationOnKey"

/// 调整位置Key
/// 0 - 使用APP提供的
/// 1 - 开启拖拽
let kMarkPositionTypeKey = "kMarkPositionTypeKey"

/// 水印位置 key
let kMarkFixedPositionKey = "kMarkFixedPositionKey"

/// 拍摄前置摄像头是否自动镜像
let kIsFrontPhotoAutoMirroOnrKey = "kIsFrontPhotoAutoMirroOnrKey"

/// 拍摄是否自动打开手电筒
let kIsAutoOpenTorchInDarkKey = "kIsAutoOpenTorchInDarkKey"

/// 是否多选水印场景
let kIsEnableMultiSceneSelect = "kIsEnableMultiSceneSelect"

/// 当前选择水印类型 key
let kWaterMarkSceneTypeKey = "kWaterMarkSceneTypeKey"
let kWaterMarkMultiSceneTypeKey = "kWaterMarkMultiSceneTypeKey"

/// 身份水印显示的 Text
let kIDCardWaterMarkTextKey = "kIDCardWaterMarkTextKey"
let kIDCardWaterMarkTextColorKey = "kIDCardWaterMarkTextColorKey"
let kWaterMarkTextTypeKey = "kWaterMarkTextTypeKey"
let kWaterMarkTextAlpha: CGFloat = 0.2

/// 虎年大吉水印显示的 Text
let kHuNianDaJiMarkTextKey = "kHuNianDaJiMarkTextKey"
let kHuNianDaJiMarkTypeKey = "kHuNianDaJiMarkTypeKey"
let kHuNianDaJiMarkName = "HuNianDaJi"

/// 自定义图片显示的 type 和名字
let kCustomImageMarkTypeKey = "kCustomImageMarkTypeKey"
let kCustomImageMarkName = "CustomImageMark"
let kCustomImageMarkShapeTypeKey = "kCustomImageMarkShapeTypeKey"

// 图片水印大小
let kWatermarkImageSizeKey = "kWatermarkImageSizeKey"

/// 拍摄后展示编辑界面
let kIsShowEditAfterShot = "kIsShowEditAfterShot"

/// 拍摄后照片保存 APP 内置相册
let kIsUseInAppAlbum = "kIsUseInAppAlbum"

/// 是否开启照片编辑功能
let kIsEnablePhotoEdit = "kIsEnablePhotoEdit"

/// 本地照片数据库表名
let kLocalAblumTable = "kLocalAblumTable"

/// 本地照片存储文件夹名
let kLocalAlbumDir = "LocalAblumDir"
/// 本地缩略图照片文件夹名
let kLocalThumbnailAlbumDir = "ThumbnailAlbumDir"

let kAlbumSinglePageSize: Int = 20

let kWaterMarkKeychainName = "com.morganwang.MWAppBase.keychain"

// 购买时的用户ID
let kUserIDKey = "userID"

// 高级版购买ID
let kWaterMarkAdvancedProductID = "com.morganwang.MWAppBase.unlockAdvancedFeature"


class MWWaterMarkProjectConsts {
    // MARK: - properties
    static let shared = MWWaterMarkProjectConsts()
    lazy var keychain = Keychain(service: kWaterMarkKeychainName)
    var isPaidAdvancedFeatures = false {
        didSet {
            updateEditState(isPaidAdvancedFeatures)
        }
    }
    
    // MARK: - init
    private init() {
        updatePaidValue()
    }
    
    // MARK: - In-App-Purchase
    fileprivate func updatePaidValue() {
        isPaidAdvancedFeatures = getKeyChainValue(from: kWaterMarkAdvancedProductID) == "1"
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
        
    func updateEditState(_ isEnabled: Bool) {
        // 跳去预览界面
        if isEnabled {
            ZLPhotoConfiguration.default().editImageConfiguration.tools = [.draw, .clip, .imageSticker, .textSticker, .filter, .adjust, .mosaic]
        }
        else {
            ZLPhotoConfiguration.default().editImageConfiguration.tools = []
        }
    }

    // MARK: - utils
    func isDragPosition() -> Bool {
        let value = UserDefaults.standard.value(forKey: kMarkPositionTypeKey) as? String
        if value == "1" { // 拖拽手势
            return true
        }
        else {
            return false
        }
    }
    
    func isUserDefaultsEnable(_ key: String) -> Bool {
        var isEnable = true
        if key == kIsAutoOpenTorchInDarkKey ||
            key == kIsEnablePhotoEdit ||
            key == kIsUseInAppAlbum {
            isEnable = false
            if let isEnableStr = UserDefaults.standard.value(forKey: key) as? String,
               isEnableStr == "1" {
                isEnable = true
            }
        }
        else {
            if let isEnableStr = UserDefaults.standard.value(forKey: key) as? String,
               isEnableStr == "0" {
                isEnable = false
            }
        }
        return isEnable
    }
    
    func getMarkFixedPosition() -> MWMarkFixedPositionType {
        if let value = UserDefaults.standard.value(forKey: kMarkFixedPositionKey) as? String {
            return MWMarkFixedPositionType(rawValue: value) ?? .bottomLeft
        }
        else {
            return .bottomLeft
        }
    }
    
    func showWatermarkDateView() -> Bool {
        let isTimeEnable = isUserDefaultsEnable(kIsWatermarkTimeOnKey)
        let isDateEnable = isUserDefaultsEnable(kIsWatermarkDateOnKey)
        if isTimeEnable || isDateEnable {
            return true
        }
        else {
            return false
        }
    }
    
    func showWatermarkLocationView() -> Bool {
        let isLocationEnable = isUserDefaultsEnable(kIsWatermarkLocationOnKey)
        return isLocationEnable
    }
    
    
    func getWaterMarkScene() -> [WaterMarkSceneType] {
        if self.isEnabledMultiSceneSelect() {
            if let value = UserDefaults.standard.value(forKey: kWaterMarkMultiSceneTypeKey) as? String {
                let list = value.components(separatedBy: ",")
                var sceneList: [WaterMarkSceneType] = []
                list.forEach { sceneStr in
                    if let scene = WaterMarkSceneType(rawValue: sceneStr) {
                        sceneList.append(scene)
                    }
                }
                if sceneList.count == 0 {
                    sceneList = [WaterMarkSceneType.normal]
                }
                return sceneList
            }
            else {
                return [WaterMarkSceneType.normal]
            }
        }
        else {
            if let value = UserDefaults.standard.value(forKey: kWaterMarkSceneTypeKey) as? String,
               let scene = WaterMarkSceneType(rawValue: value) {
                return [scene]
            }
            else {
                return [.normal]
            }
        }
    }
        
    func getWaterMarkTextType() -> MWWaterMarkIDPhotoType {
        if let value = UserDefaults.standard.value(forKey: kWaterMarkTextTypeKey) as? String {
            return MWWaterMarkIDPhotoType(rawValue: value) ?? .simple
        }
        else {
            return .simple
        }
    }
    
    func getIDCardWaterMarkText() -> String {
        if let value = UserDefaults.standard.value(forKey: kIDCardWaterMarkTextKey) as? String {
            return value
        }
        else {
            return MWAppBaseLocalizedString("SampleText").reslove()
        }
    }
    
    func getIDCardWaterMarkTextColor() -> String {
        if let value = UserDefaults.standard.value(forKey: kIDCardWaterMarkTextColorKey) as? String {
            return value
        }
        else {
            let colorStr = UIColor.hexStringFromColor(color: UIColor.orange)
            return colorStr
        }
    }
    
    func getHuNianDaJiMarkText() -> String {
        if let value = UserDefaults.standard.value(forKey: kHuNianDaJiMarkTextKey) as? String {
            return value
        }
        else {
            return "虎年大吉"
        }
    }
    
    func getHuNianDaJiType() -> Int {
        if let value = UserDefaults.standard.value(forKey: kHuNianDaJiMarkTypeKey) as? String {
            return (value as NSString).integerValue
        }
        else {
            return 0
        }
    }
    
    func getCustomImageMarkType() -> Int {
        if let value = UserDefaults.standard.value(forKey: kCustomImageMarkTypeKey) as? String {
            return (value as NSString).integerValue
        }
        else {
            return 0
        }
    }
    
    func getkCustomImageMarkShapeType() -> CustomImageShapeType {
        if let value = UserDefaults.standard.value(forKey: kCustomImageMarkShapeTypeKey) as? String {
            let valueInt = (value as NSString).integerValue
            return CustomImageShapeType(rawValue: valueInt) ?? .Round
        }
        else {
            return .Round
        }
    }
    
    func getDisplayWatermarkImage(_ type: WaterMarkSceneType? = nil) -> UIImage? {
        let sceneType = type
        if sceneType == nil {
            let sceneTypes = getWaterMarkScene()
            if sceneTypes.contains(.hunianlogo) {
                return getDisplayHuNianDaJiImage()
            }
            else if sceneTypes.contains(.customImage) {
                return getDisplayCustomMarkImage()
            }
            else {
                return nil
            }
        }
        else {
            if sceneType == .hunianlogo {
                return getDisplayHuNianDaJiImage()
            }
            else if sceneType == .customImage {
                return getDisplayCustomMarkImage()
            }
            else {
                return nil
            }
        }

    }
    
    fileprivate func getDisplayHuNianDaJiImage() -> UIImage {
        if let image = UIImage.getSavedImage(named: kHuNianDaJiMarkName) {
            return image
        }
        else {
            return UIImage(named: "hunian_mark")!
        }
    }
    
    fileprivate func getDisplayCustomMarkImage() -> UIImage {
        if let image = UIImage.getSavedImage(named: kCustomImageMarkName) {
            return image
        }
        else {
            return UIImage(named: "tiger_type_1")!
        }
    }
    
    func getWatermarkImageSize() -> CGFloat? {
        if let value = UserDefaults.standard.value(forKey: kWatermarkImageSizeKey) as? NSString {
            return CGFloat(value.floatValue)
        }
        else {
            return nil
        }
    }
    
    func getMarkPositionTypeValue() -> String {
        if let value = UserDefaults.standard.value(forKey: kMarkPositionTypeKey) as? String {
            return value
        }
        else { // 默认为系统提供的
            return "0"
        }
    }
    
    
    func getDragPositionKey(_ sceneType: WaterMarkSceneType) -> String {
        if isEnabledMultiSceneSelect() {
            return kMarkDragPositionKey + sceneType.rawValue
        }
        else {
            return kMarkDragPositionKey
        }
    }
    
    func getDragPositionPoint(_ sceneType: WaterMarkSceneType) -> CGPoint {
        let key = getDragPositionKey(sceneType)
        return getDragPositionPointWithKey(key)
    }
    
    fileprivate func getDragPositionPointWithKey(_ keyStr: String) -> CGPoint {
        if let value = UserDefaults.standard.value(forKey: keyStr) as? String {
            return NSCoder.cgPoint(for: value)
        }
        else {
            let x = MWScreenWidth / 2.0
            let y = (MWScreenHeight - MWCameraBottomView.viewHeight()) / 2.0
            return CGPoint(x: x, y: y)
        }
    }
    
    func isEnabledMultiSceneSelect() -> Bool {
        if let value = UserDefaults.standard.value(forKey: kIsEnableMultiSceneSelect) as? String,
            value == "1" {
                return true
        }
        else {
            return false
        }
    }

    
    // MARK: - action
    
    
    // MARK: - other
    

}
