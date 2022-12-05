//
//  CommonClasses.swift
//  DittoFashionMarketBeta
//
//  Created by Bhavneet Singh on 23/11/17.
//  Copyright © 2017 Bhavneet Singh. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import MobileCoreServices
import SwiftMessages

class CommonFunctions {

    static var isGuestLogin:Bool = false
    static let web = NetworkLayer()
    static var isFromSignUp = false
    static var navigationTitleImageView = UIImageView()
    static func checkForInternet() -> Bool{
        let flag = isNetworkReachable()
        if flag{
            return true
        }else{
            CommonFunctions.showToastWithMessage("Please check your internet connection!")
            return false
        }
    }
    
    static let loader = NVActivityIndicatorView(frame: CGRect(x: UIDevice.width/2 - 25, y: UIDevice.height/2 - 25, width: 50, height: 50), type: .circleStrokeSpin, color: AppColors.themeColor, padding: 10)
    
    /// Show Toast With Message
    static func showToastWithMessage(_ msg: String, completion: (() -> Swift.Void)? = nil) {

        DispatchQueue.mainQueueAsync {
            
            let warning = MessageView.viewFromNib(layout: .messageView)
            warning.configureTheme(.error)
            warning.frame = CGRect(x: 0, y: 0, width: 20, height: 90)
            warning.layoutIfNeeded()
            warning.configureDropShadow()
            warning.configureContent(title: "", body: msg)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warning.bodyLabel?.textColor = .white
            warning.bodyLabel?.font = AppFonts.Regular.withSize(16)
            warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            SwiftMessages.show(config: warningConfig, view: warning)
        }
    }
    
    /// Delay Functions
    class func delay(delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when) {
            closure()
            
        }
    }
    
    /// Show Action Sheet With Actions Array
    class func showActionSheetWithActionArray(_ title: String?, message: String?,
                                              viewController: UIViewController,
                                              alertActionArray : [UIAlertAction],
                                              preferredStyle: UIAlertController.Style)  {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        alertActionArray.forEach{ alert.addAction($0) }
        
        DispatchQueue.mainQueueAsync {
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    /// Show Activity Loader
    class func showActivityLoader() {
        DispatchQueue.mainQueueAsync {
            if let vc = AppDelegate.shared.window?.rootViewController {
                vc.startNYLoader()
            }
        }
    }
    
    /// Hide Activity Loader
    class func hideActivityLoader() {
        DispatchQueue.mainQueueAsync {
            if let vc = AppDelegate.shared.window?.rootViewController {
                vc.stopNYLoader()
            }
        }
    }
    
    
    static func actionOnTags(_ id:String,action:Bool,completion:@escaping(()->())){
        let param:JSONDictionary = ["tagId":id,"type":action ? "save" : "remove"]
        web.request(from: WebService.saveUnsaveTags, param: param, method: .PUT, header: [:], loader: false) { (data, er) in
            if let e = er{
                CommonFunctions.showToastWithMessage(e.localizedDescription)
            }else{
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    class func guestLogin(){
        let param:JSONDictionary = ["deviceId":DeviceDetail.deviceId]
        web.request(from: WebService.guestLogin, param: param, method: .POST, header: [:]) { (data, error) in
            if let e = error{
                CommonFunctions.showToastWithMessage(e.localizedDescription)
            }else{
                if let _ = data{
                    isGuestLogin = true
                    DispatchQueue.main.async {
                        AppRouter.goToHome()
                    }
                }
            }
        }
    }
}
