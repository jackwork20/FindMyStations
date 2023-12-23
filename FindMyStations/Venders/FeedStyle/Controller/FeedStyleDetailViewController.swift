//
//  FeedStyleDetailViewController.swift
//  FindMyStations
//
//  Created by jack on 2023/10/29.
//

import Foundation

class FeedStyleDetailViewController: UIViewController, SuperPlayerDelegate,FeedDetailViewDelegate {
    
    lazy var detailView = {
        let detailView = FeedDetailView()
        detailView.delegate = self
        return detailView
    }()
    
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
        self.view.addSubview(self.detailView)
        self.detailView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let leftButton = UIButton(type: .custom)
        leftButton.frame = CGRectMake(5, 0, 150, 35)
        leftButton.setBackgroundImage(UIImage(named: "icon_nav_back"), for: .normal)
        leftButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        leftButton.sizeToFit()
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: leftButton)]
//        self.title = playerLocalize("SuperPlayerDemo.VideoFeeds.detailtitle")
        self.title = "Station Detail Video List"
    }
    
    @objc func backClick() {
        self.detailView.destory()
        self.navigationController?.popViewController(animated: false)
    }
    
    var detailListdata: [Any] = [] {
        didSet {
            self.detailView.setListData(detailListdata)
        }
    }
    
    var headModel: FeedHeadModel? {
        didSet {
            self.detailView.model = headModel!
        }
    }
    
    var videoModel: FeedVideoModel? {
        didSet {
            self.detailView.videoModel = videoModel!
        }
    }
    
    var superPlayView: SuperPlayerView? {
        didSet {
            self.detailView.superPlayView = superPlayView!
            self.superPlayView!.delegate = self
        }
    }
    
    func screenRotation(_ fullScreen: Bool) {
        AppOrientation.interfaceOrientationMask = fullScreen ? .landscapeRight : .portrait
        self.movSetNeedsUpdateOfSupportedInterfaceOrientations()
    }
    
    func movSetNeedsUpdateOfSupportedInterfaceOrientations() {
        self.smovSetNeedsUpdateOfSupportedInterfaceOrientations()
    }
}
