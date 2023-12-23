//
//  ViewController.swift
//  MoviePlayer
//
//  Created by jack on 2023/8/9.
//

import UIKit

struct HomeData {
    let icon: String
    let title: String
    let desc: String
}

class ViewController: UIViewController {
    var isAdOpenShow: Bool = false
    let kReusableID = "kReusableID"
    
    let dataList: [HomeData] = [
        HomeData(icon: "icon_default", title: "Default Station", desc: "Display default station information"),
        HomeData(icon: "icon_photo", title: "Photo Station", desc: "Display album information"),
        HomeData(icon: "icon_folder", title: "File Station", desc: "Displays system file app information"),
        HomeData(icon: "icon_play", title: "Demo Video Station", desc: "Show video station example"),
        HomeData(icon: "icon_audio", title: "Demo Music Station", desc: "Show music station example"),
        HomeData(icon: "icon_play", title: "Station Movie List", desc: "Show station movie List")
//        HomeData(icon: "icon_play", title: "Demo Video Station(XX)", desc: "Show video station example")
    ]
    
    public lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 40, right: 12)
        flowLayout.minimumLineSpacing = 15
        
        let screeWidth = UIScreen.main.bounds.width
        let valueWidth = screeWidth - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        let itemWidth: CGFloat = valueWidth
        let itemHeight: CGFloat = 100
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(HomeStationCollectionViewCell.self, forCellWithReuseIdentifier: kReusableID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = showPasswordVC()
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(rgb: 0xffffff)!]
                
        let colors: [CGColor] = [UIColor(red: 19/255.0, green: 41/255.0, blue: 75/255.0, alpha: 1).cgColor,
                                 UIColor(red: 5/255.0, green: 12/255.0, blue: 23/255.0, alpha: 1).cgColor]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        collectionView.backgroundColor = .clear
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        
        let barButton = UIButton(type: .custom)
        barButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        barButton.addTarget(self, action: #selector(onRightClick), for: .touchUpInside)
        barButton.setImage(UIImage(named: "add_noremal"), for: .normal)
        barButton.setImage(UIImage(named: "add_press"), for: .selected)
        barButton.imageView?.contentMode = .scaleAspectFit
        let barItem = UIBarButtonItem(customView: barButton)
        self.tabBarController?.navigationItem.rightBarButtonItem = barItem
        
        AppOpenAdManager.shared.appOpenAdManagerDelegate = self
        
//        AppOpenAdManager.shared.showAdIfAvailable(viewController: self)
    }
    
    @objc func onRightClick() {
        self.navigationController?.pushViewController(StationMgrViewController(), animated: true)
    }
    
    func showPasswordVC() -> Bool {
        if let savedPass = UserDefaults.standard.value(forKey: PasswordViewController.KEY_PRIVATE_PASSWORD) as? String,
           savedPass.count > 0 {
            self.present(PasswordViewController(pageType: .PageTypeValid), animated: false)
            return true
        }
        return false
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReusableID, for: indexPath)
        if let cell = cell as? HomeStationCollectionViewCell {
            cell.setData(data: self.dataList[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let path = Bundle.main.path(forResource: "Res", ofType: nil)
            self.navigationController?.pushViewController(BaseCollectionViewController(rootPath: path!, titleTxt: "Default Station"), animated: true)
        } else if indexPath.row == 1 {
            self.navigationController?.pushViewController(PhotoVideoViewController(rootPath: FilePath.photo.getDirPath()), animated: true)
        } else if indexPath.row == 2 {
            self.navigationController?.pushViewController(DocumentViewController(rootPath: FilePath.doc.getDirPath()), animated: true)
        } else if indexPath.row == 3 {
            self.navigationController?.pushViewController(FeedStylePlayViewController(dataCoordinator: VidevoDataCoordinator()), animated: true)
        } else if indexPath.row == 4 {
            self.navigationController?.pushViewController(RadioViewController(navigationVC: self.navigationController!), animated: true)
        } else if indexPath.row == 5 {
            self.navigationController?.pushViewController(FeedStylePlayViewController(dataCoordinator: DemoVideoStationDataCoordinator()), animated: true)
        } /*else if indexPath.row == 6 {
            self.navigationController?.pushViewController(FeedStylePlayViewController(dataCoordinator: StationParserDataCoordinator()), animated: true)
        }*/
    }
}

extension ViewController: AppOpenAdManagerDelegate {
    func appOpenAdManagerAdDidComplete(_ appOpenAdManager: AppOpenAdManager) {
        if !isAdOpenShow {
            isAdOpenShow = true
            AppOpenAdManager.shared.showAdIfAvailable(viewController: self)
        }
    }
}
