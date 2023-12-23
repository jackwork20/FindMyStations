//
//  MenuViewController.swift
//  MoviePlayer
//
//  Created by jack on 2023/9/6.
//

import Foundation
import SDWebImage

class MenuViewController: BaseTableViewController {
    enum PlaySetting: String {
        case rate = "rate"
        case autoPlay = "autoPlay"
        case allowsExternalPlayback = "allowsExternalPlayback"
        case allowsAirPlay = "allowsAirPlay"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colors: [CGColor] = [UIColor(red: 19/255.0, green: 41/255.0, blue: 75/255.0, alpha: 1).cgColor,
                                 UIColor(red: 5/255.0, green: 12/255.0, blue: 23/255.0, alpha: 1).cgColor]

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        var passwordItem: [BaseTableCellItem] = []
        
        if let savedPass = UserDefaults.standard.value(forKey: PasswordViewController.KEY_PRIVATE_PASSWORD) as? String,
           savedPass.count > 0 {
            passwordItem = [BaseTableCellItem(title: "Change Password", action: {
                let passVC = PasswordViewController(pageType: .PageTypeSet)
                self.present(passVC, animated: true)
            }),
            BaseTableCellItem(title: "Close password", action: {
                let passVC = PasswordViewController(pageType: .PageClean)
                self.present(passVC, animated: true)
            })]
        } else {
            passwordItem = [BaseTableCellItem(title: "Setup password", action: {
                let passVC = PasswordViewController(pageType: .PageTypeSet)
                self.present(passVC, animated: true)
            })]
        }
        
        self.data = [
            BaseTableSectionItem(section: "Station Manager", cellItems: [
                BaseTableCellItem(title: "Station Manager", action: {
                    self.navigationController?.pushViewController(StationMgrViewController(), animated: true)
                })
            ]),
            BaseTableSectionItem(section: "Play settings", cellItems: [
                BaseTableCellItem(title: "Auto Play", action: {
                }, switchAction: { isOn in
                    UserDefaults.standard.set(isOn, forKey: PlaySetting.autoPlay.rawValue)
                }),
                BaseTableCellItem(title: "Allow external play", action: {
                }, switchAction: { isOn in
                    UserDefaults.standard.set(isOn, forKey: PlaySetting.allowsExternalPlayback.rawValue)
                }),
                BaseTableCellItem(title: "Allow AirPlay", action: {
                }, switchAction: { isOn in
                    UserDefaults.standard.set(isOn, forKey: PlaySetting.allowsAirPlay.rawValue)
                }),
                BaseTableCellItem(title: "Clear Cache", action: {
                    SDImageCache.shared.clearMemory()
                    Toast(text: "Clear cache success.", duration: Delay.short).showToast()
                })
            ]),
            BaseTableSectionItem(section: "Settings", cellItems: passwordItem),
            BaseTableSectionItem(section: "Privacy Policy", cellItems: [
                BaseTableCellItem(title: "App Privacy Policy", action: {
                    UIApplication.shared.openURL(URL(string: "https://github.com/jackwork20/MoviePlayer-Privacy-Policy/blob/main/index.md")!)
                }),
                BaseTableCellItem(title: "Player Privacy Policy", action: {
                    UIApplication.shared.openURL(URL(string: "https://cloud.tencent.com/document/product/881/65679")!)
                }),
                BaseTableCellItem(title: "Player Compliance Guide", action: { [weak self] in
                    UIApplication.shared.openURL(URL(string: "https://cloud.tencent.com/document/product/881/97550")!)
                })
            ]),
            BaseTableSectionItem(section: "Other", cellItems: [
                BaseTableCellItem(title: "Feedback", action: {
                    self.sendFeedbackEmail()
                }),
                BaseTableCellItem(title: "About", action: { [weak self] in
                    self?.showVersion()
                })
            ])
        ]
    }
}

extension MenuViewController {
    func showVersion() {
        let infoDictionary = Bundle.main.infoDictionary!
        let appDisplayName = infoDictionary["CFBundleDisplayName"] as? String ?? ""
        let majorVersion: String = infoDictionary["CFBundleShortVersionString"] as? String ?? ""
        let minorVersion: String = infoDictionary["CFBundleVersion"] as? String ?? ""
        let alertController = UIAlertController(title: appDisplayName, message: "Version: " + majorVersion + "(\(minorVersion))", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
}
