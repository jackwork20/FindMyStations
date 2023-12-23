//
//  BaseStationCollectionViewController.swift
//  StationPlayer
//
//  Created by jack on 2023/9/27.
//

import Foundation

class BaseStationCollectionViewController: UIViewController {
    
    var movieList: [MovieInfo] = []
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
        collectionView.register(StationCollectionViewCell.self, forCellWithReuseIdentifier: kReusableID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
//        collectionView.backgroundColor = .black
        return collectionView
    }()
}


extension BaseStationCollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.left.bottom.top.right.equalToSuperview()
        }
        
        self.view.addSubview(self.loadingView)
        self.loadingView.snp.makeConstraints { make in
            make.width.height.equalTo(37)
            make.center.equalToSuperview()
        }
        
        self.collectionView.emptyDataSetSource = self
        self.collectionView.emptyDataSetDelegate = self
        
        self.showLoadingView()
        self.hideLoadingView()
    }
    
    func refreshVideos(station: Station) {
        self.movieList = []
        if let json = station.jsonContent {
            self.movieList = MovieInfoMgr.shared.parse(jsonString: json) ?? []
        }
        self.collectionView.reloadData()
    }
}

// MARK: DataSource
extension BaseStationCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReusableID, for: indexPath)
        if let cell = cell as? StationCollectionViewCell {
            cell.injectMovieInfo(movieInfo: self.movieList[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movice = self.movieList[indexPath.row]
        self.navigationController?.pushViewController(StationPlayerViewController(movice), animated: true)
    }
}


extension BaseStationCollectionViewController {
    func showLoadingView() {
        self.loadingView.startAnimating()
        self.loadingView.superview?.bringSubviewToFront(self.loadingView)
    }
    
    func hideLoadingView() {
        self.loadingView.stopAnimating()
    }
}

extension BaseStationCollectionViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
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
        let text =  clickStationGuide //"可点击上面图标进行站点管理"
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
    }
    
    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        return nil
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap view: UIView) {
        self.navigationController?.pushViewController(StationMgrViewController(), animated: true)
    }
}
