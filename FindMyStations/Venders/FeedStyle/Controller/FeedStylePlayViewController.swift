//
//  FeedStylePlayViewController.swift
//  FindMyStations
//
//  Created by jack on 2023/10/29.
//

import Foundation

class FeedStylePlayViewController: UIViewController {
    lazy var feedPlayView: SuperFeedPlayView = {
        let playView = SuperFeedPlayView()
        playView.delegate = self
        return playView
    }()
    
    let dataCoordinator: BaseDataCoordinator
    required init(dataCoordinator: BaseDataCoordinator) {
        self.dataCoordinator = dataCoordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    lazy var dataCoordinator =  { VidevoDataCoordinator() } ()
    
    var superPlayView: UIView?
    
    var pageIndex: Int = 1
    
    var isPushToFullScreen: Bool = false
    var isPushToDetail: Bool = false
    
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
        
        self.view.addSubview(self.feedPlayView)
        self.feedPlayView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalToSuperview()
            }
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        refreshNewFeedData()
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
        self.title = "Station Video List"
    }
    
    @objc func backClick() {
        self.feedPlayView.removeVideo()
        self.navigationController?.popViewController(animated: false)
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (self.isPushToDetail) {
            if let superPlayView = self.superPlayView {
                self.feedPlayView.addSuperPlay(superPlayView)
            }
            self.isPushToDetail = false
        }
        if (self.isPushToFullScreen) {
            if let superPlayView = self.superPlayView {
                self.feedPlayView.addSuperPlay(superPlayView)
            }
            self.isPushToFullScreen = false
        }
    }
    
    // return videoURL
    func getPlayInfo(descUrl: String, completion: @escaping (String?) -> Void) {
        self.dataCoordinator.queryDescInfo(descUrl: descUrl) { playUrl in
           // print("playUrl: \(playUrl)")
            completion(playUrl)
        }
    }

    func loadStationData(pageIndex: Int = 0, success: @escaping ([FeedVideoModel]) -> Void) {
        self.dataCoordinator.loadVideos(pageIndex: pageIndex) { movieList in
            let feedModels =  movieList.map { movieInfo in
                let feedModel = FeedVideoModel()
                feedModel.title = movieInfo.title
                feedModel.infoURL = movieInfo.href
                feedModel.coverUrl = movieInfo.imgSrc
                feedModel.isDirect = movieInfo.isDirect
                return feedModel
            }

            DispatchQueue.global(qos: .default).async { [weak self] in
                let queryGroup = DispatchGroup()
                for obj in feedModels {
                    if obj.isDirect {
                        obj.videoURL = obj.infoURL
                    } else {
                        queryGroup.enter()
                        self?.getPlayInfo(descUrl: obj.infoURL, completion: { playUrl in
                            obj.videoURL = playUrl ?? ""
                            queryGroup.leave()
                        })
                    }
                }
                queryGroup.notify(queue: .main) {
                    let models = feedModels.filter({ item in
                        !item.videoURL.isEmpty
                    })
                    if !models.isEmpty {
                        success(models)
                    }
                }
            }
        }
    }
}

extension FeedStylePlayViewController: SuperFeedPlayViewDelegate {
    func refreshNewFeedData() {
        loadStationData { [weak self] list in
            guard let self = self else { return }
            self.feedPlayView.finishRefresh()
            self.feedPlayView.setFeedData(list, isCleanData: true)
        }
    }
    
    func loadNewFeedData(withPage page: Int) {
        pageIndex += 1
        loadStationData(pageIndex: pageIndex) { [weak self] list in
            guard let self = self else { return }
            self.feedPlayView.finishLoadMore()
            self.feedPlayView.setFeedData(list, isCleanData: false)
        }
    }
    
    func showFeedDetailView(with model: FeedHeadModel, videoModel: FeedVideoModel, play superPlayView: SuperPlayerView) {
        self.isPushToDetail = true
        self.superPlayView = superPlayView

        var detailVC: FeedStyleDetailViewController?
        detailVC = FeedStyleDetailViewController()
        detailVC?.headModel = model
        detailVC?.superPlayView = superPlayView
        self.loadStationData { list in
            detailVC?.detailListdata = list
        }
        detailVC?.videoModel = videoModel
        self.navigationController?.pushViewController(detailVC!, animated: false)
    }
    
    func showFullScreenView(withPlay superPlayerView: SuperPlayerView) {
        self.isPushToFullScreen = true
        self.superPlayView = superPlayerView
        let vc = FeedFullScreenViewController()
        vc.playerView = superPlayerView
        navigationController?.pushViewController(vc, animated: false)
    }

    
    func screenRotation(_ fullScreen: Bool) {
        
    }
}
