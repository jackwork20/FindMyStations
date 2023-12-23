//
//  BaseListViewController.swift
//  MoviePlayer
//
//  Created by jack on 2023/8/17.
//

import Foundation
import MJRefresh

class BaseCollectionViewController: BaseStationVideoViewController {
    let rootPath: String
    let titleTxt: String?
        
    required init(rootPath: String, titleTxt: String? = nil) {
        self.rootPath = rootPath
        self.titleTxt = titleTxt
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var movieList: [VideoItem] = []
    let itemCount = 2
    let kReusableID = "kReusableID"
    
    private let loadingView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    public lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 12
        flowLayout.minimumInteritemSpacing = 12
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 40, right: 12)
        
        let screeWidth = UIScreen.main.bounds.width
        let valueWidth = screeWidth - flowLayout.sectionInset.left - flowLayout.sectionInset.right - CGFloat(itemCount - 1) * flowLayout.minimumInteritemSpacing
        let itemWidth: CGFloat = valueWidth / CGFloat(itemCount)
        let itemHeight = itemWidth * 0.8
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: kReusableID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    func handleImport() {
        
    }
    
    override func refreshData(station: Station) {
        self.refreshVideos()
    }
}


extension BaseCollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.titleTxt ?? ""
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.left.bottom.top.right.equalToSuperview()
        }
        
        self.view.addSubview(self.loadingView)
        self.loadingView.snp.makeConstraints { make in
            make.width.height.equalTo(37)
            make.center.equalToSuperview()
        }
        
//        self.xlTableView.emptyDataSetSource = self;
//        self.xlTableView.emptyDataSetDelegate = self;
        
        self.collectionView.emptyDataSetSource = self
        self.collectionView.emptyDataSetDelegate = self
             
        // 下拉刷新
        self.collectionView.mj_header = MJRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else {
                return
            }
            self.refreshVideos()
        })
        
        self.showLoadingView()
        self.refreshVideos()
        self.hideLoadingView()
        
        let colors: [CGColor] = [UIColor(red: 19/255.0, green: 41/255.0, blue: 75/255.0, alpha: 1).cgColor,
                                 UIColor(red: 5/255.0, green: 12/255.0, blue: 23/255.0, alpha: 1).cgColor]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func refreshVideos() {
        self.movieList = VideoHelper.getAllVideos(self.rootPath)
        self.collectionView.reloadData()
    }
}

// MARK: DataSource
extension BaseCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReusableID, for: indexPath)
        if let cell = cell as? MovieCollectionViewCell {
            cell.injectMovieInfo(movieInfo: self.movieList[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movice = self.movieList[indexPath.row]
        self.navigationController?.pushViewController(PlayerViewController(movice), animated: true)
    }
}


extension BaseCollectionViewController {
    func showLoadingView() {
        self.loadingView.startAnimating()
        self.loadingView.superview?.bringSubviewToFront(self.loadingView)
    }
    
    func hideLoadingView() {
        self.loadingView.stopAnimating()
    }
}

extension BaseCollectionViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "no_data")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = noStationInfo //"没有视频信息"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16.0),
            .foregroundColor: UIColor.gray
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = clickStationGuide //"可点击上面图标进行视频导入"
        var attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14.0),
                .foregroundColor: UIColor.lightGray,
                .paragraphStyle: NSMutableParagraphStyle()
            ]

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.alignment = .center
            attributes[.paragraphStyle] = paragraphStyle

            return NSAttributedString(string: text, attributes: attributes)
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool { true }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        self.movieList.count == 0
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat { 0 }
    

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        return nil
//        let attributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont.boldSystemFont(ofSize: 16.0)
//        ]
//        let btnTitle = "立即添加"
//        return NSAttributedString(string: btnTitle, attributes: attributes)
    }
    
    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        return nil
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap view: UIView) {
        self.handleImport()
    }
}
