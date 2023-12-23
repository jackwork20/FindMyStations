//
//  MovieCollectionViewCell.swift
//  MoviePlayer
//
//  Created by jack on 2023/8/12.
//

import Foundation
import UIKit
import SDWebImage

/**
 布局方式，上下布局，上面为一张图片，下方为文本，时长在图片右下角
 图片高度，width：fill  height: 宽度的一半
 文本高度为50，写死，距离底部为10，
 */
class StationCollectionViewCell: UICollectionViewCell {
    
    private var movieInfo: MovieInfo?
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(rgb: 0xffffff, alpha: 0.1)
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
        
        self.imageView.clipsToBounds = true
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLabel)
                
        self.imageView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalToSuperview().offset(-30)
        }
        self.titleLabel.snp.makeConstraints { make in
            make.width.equalTo(self.imageView.snp.width)
            make.height.equalTo(30)
            make.top.equalTo(self.imageView.snp.bottom)
        }
        
        self.titleLabel.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func injectMovieInfo(movieInfo: MovieInfo) {
        self.movieInfo = movieInfo
        
        self.titleLabel.text = movieInfo.title
        if let url = URL(string: movieInfo.imgSrc) {
            self.imageView.sd_setImage(with: url)
        }
    }
}
