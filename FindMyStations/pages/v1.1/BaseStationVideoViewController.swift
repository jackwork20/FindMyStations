//
//  BaseStationVideoViewController.swift
//  StationPlayer
//
//  Created by jack on 2023/10/2.
//

import Foundation

// 站点页面基类
public class BaseStationVideoViewController: UIViewController {
    func refreshData(station: Station) {
        
    }
}

public class StationVideoViewController: BaseStationVideoViewController {
    let collectionVC = BaseStationCollectionViewController()

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.addChild(collectionVC)
        self.view.addSubview(collectionVC.view)
    }
    
    override func refreshData(station: Station) {
        self.collectionVC.refreshVideos(station: station)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
