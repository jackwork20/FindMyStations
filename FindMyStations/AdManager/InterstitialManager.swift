////
////  InterstitialManager.swift
////  MoviePlayer
////
////  Created by yytong on 2023/8/21.
////
//
//import Foundation
//import GoogleMobileAds
//
///// 插页广告
//class InterstitialManager: NSObject {
//    static let shared = InterstitialManager()
//    
//    private var interstitial: GADInterstitialAd?
//    lazy var rootViewController: UIViewController? = {
//        UIApplication.shared.keyWindow?.rootViewController
//    }()
//    
//    func loadAd() {
//        let request = GADRequest()
//        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-9066624869423812/9779027950",
//                               request: request,
//                               completionHandler: { [self] ad, error in
//            if let error = error {
//                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
//                return
//            }
//            interstitial = ad
//            interstitial?.fullScreenContentDelegate = self
//        }
//        )
//    }
//    
//    func showAd() {
//        if let interstitial = interstitial {
//            if let rootVC = self.rootViewController {
//                interstitial.present(fromRootViewController: rootVC)
//            }
//        }
//    }
//}
//
//extension InterstitialManager: GADFullScreenContentDelegate {
//    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//        print("Ad did fail to present full screen content.")
//    }
//    
//    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        print("Ad will present full screen content.")
//    }
//    
//    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        print("Ad did dismiss full screen content.")
//        self.loadAd()
//    }
//}
