//
//  AppDelegate.swift
//  Stoke
//
//  Created by Admin on 23/02/21.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let shared = UIApplication.shared.delegate as! AppDelegate
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 3.0)
        AppRouter.checkUserFlow()
        setupIQKeyboard()
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        GoogleLoginController.shared.configure(withClientId: AppConstants.googleApiKey)
        AWSController.setupAWS()
        return true
        
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {

        let scema = url.absoluteString
        if scema.contains(s: "com.stoke.beta"){
            let queryItems = URLComponents(string: url.absoluteString)?.queryItems
            let token = queryItems?.filter({$0.name == "token"}).first?.value ?? ""
            let type = queryItems?.filter({$0.name == "type"}).first
            let checkType = type?.value ?? ""
            if checkType == "2"{
                AppRouter.openRestPassword(token)
            }
            return true
        }else{
            ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
            return GoogleLoginController.shared.handleUrl(url, options: options)
        }
    }
    
    func setupIQKeyboard() {
           
           IQKeyboardManager.shared.enable = true
           IQKeyboardManager.shared.layoutIfNeededOnUpdate = true
           IQKeyboardManager.shared.shouldResignOnTouchOutside = true
           IQBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: AppColors.themeColor,
                                                                .font: AppFonts.Regular.withSize(12)],
                                                               for: .normal)
           IQKeyboardManager.shared.toolbarTintColor = AppColors.themeColor
           UITextField.appearance().tintColor = AppColors.themeColor
           UITextView.appearance().tintColor = AppColors.themeColor
       }

}

