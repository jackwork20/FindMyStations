//
//  AppDelegate.swift
//  MoviePlayer
//
//  Created by jack on 2023/8/9.
//

import UIKit
import FirebaseCore
import GoogleMobileAds

@objcMembers
class AppOrientation: NSObject {
    static var interfaceOrientationMask: UIInterfaceOrientationMask = .portrait
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 初始化Firebase统计
        FirebaseApp.configure()
        
        // 添加测试设备
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "95cb919a71fa2486ad641e3a6ce0bd79", "f3a8222be10bacaa504cab2f9eb0036f" ]
        
        // 初始化admob
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        AppOpenAdManager.shared.loadAd()
        
        // 初始化腾讯视频SDK
        TXLiveBase.setConsoleEnabled(false)
        let licenceURL = "https://license.vod2.myqcloud.com/license/v2/1305288191_1/v_cube.license"
        let licenceKey = "da47e58e9ae97cd8e7e983513f0f0ab6"
        TXLiveBase.setLicenceURL(licenceURL, key: licenceKey)
        TXPlayerGlobalSetting.setMaxCacheSize(1024 * 2)
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppOrientation.interfaceOrientationMask
    }
}

extension UIApplication {
    var currentWindow: UIWindow? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first{
            return window
        }
        return nil
    }
}
