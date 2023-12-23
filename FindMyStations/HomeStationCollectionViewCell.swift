//
//  HomeStationCollectionViewCell.swift
//  FindMyStations
//
//  Created by jack on 2023/10/17.
//

import Foundation

class HomeStationCollectionViewCell: UICollectionViewCell {
    private var homeData: HomeData?
    
    private let logImgView = UIImageView()
    private let titleLabel = UILabel()
    private let descLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(rgb: 0xffffff, alpha: 0.1)
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
        
        self.logImgView.clipsToBounds = true
        self.contentView.addSubview(self.logImgView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.descLabel)
        
        self.logImgView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.logImgView.snp.right).offset(15)
            make.centerY.equalTo(self.snp.centerY).offset(-15)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
        self.descLabel.snp.makeConstraints { make in
            make.left.equalTo(self.titleLabel.snp.left)
            make.centerY.equalTo(self.snp.centerY).offset(15)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        
        self.titleLabel.textAlignment = .left
        self.descLabel.textAlignment = .left
        self.titleLabel.font = UIFont.systemFont(ofSize: 18)
        self.descLabel.font = UIFont.systemFont(ofSize: 16)
        self.titleLabel.textColor = .white
        self.descLabel.textColor = UIColor(rgb: 0xffffff, alpha: 0.7)
        self.descLabel.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(data: HomeData) {
        self.homeData = data
        self.titleLabel.text = data.title
        self.descLabel.text = data.desc
        self.logImgView.image = UIImage(named: data.icon)?
            .imageWithColor(tintColor: UIColor(rgb: 0x2d7afe))
    }
    
}
