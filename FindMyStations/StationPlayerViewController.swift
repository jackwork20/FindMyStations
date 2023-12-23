//
//  PlayerViewController.swift
//  MoviePlayer
//
//  Created by jack on 2023/8/13.
//

import Foundation
import UIKit
import AVFoundation

class StationPlayerViewController: UIViewController {
    private let movieInfo: MovieInfo

    init(_ movieInfo: MovieInfo) {
        self.movieInfo = movieInfo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?

    
    private let indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.movieInfo.title
        
        self.view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.width.height.equalTo(37)
            make.centerY.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
        }
        
        if let urlStr = self.movieInfo.href.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: urlStr) {
            player = AVPlayer(url: url)
            playerLayer =  AVPlayerLayer()
            
            playerLayer = AVPlayerLayer(player: player!)
            playerLayer?.frame = view.bounds
            player?.play()
            self.view.layer.addSublayer(playerLayer!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
