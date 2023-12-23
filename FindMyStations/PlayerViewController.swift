//
//  PlayerViewController.swift
//  MoviePlayer
//
//  Created by jack on 2023/8/13.
//

import Foundation
import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    private let movieInfo: VideoItem

    init(_ movieInfo: VideoItem) {
        self.movieInfo = movieInfo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
//    private let playerView: VersaPlayerView = VersaPlayerView()
//    private let controls: VersaPlayerControls = VersaPlayerControls()
    
    private let indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addSubview(self.playerView)
        
        self.title = self.movieInfo.name
    /*
        self.playerView.snp.makeConstraints { make in
            make.left.top.bottom.right.equalToSuperview()
        }
     */
        
        self.view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.width.height.equalTo(37)
            make.centerY.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
        }
/*
        playerView.layer.backgroundColor = UIColor.black.cgColor
        playerView.playbackDelegate = self
        playerView.use(controls: controls)
        playerView.controls?.behaviour.shouldAutohide = true
*/
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

/*
extension PlayerViewController: VersaPlayerPlaybackDelegate {
    func playbackShouldBegin(player: VersaPlayer) -> Bool {
        indicatorView.startAnimating()
        debugPrint("[play callback] playbackShouldBegin")
        return true
    }
    
    func playbackDidJump(player: VersaPlayer) {
        debugPrint("[play callback] playbackDidJump")
    }
    
    func playbackWillBegin(player: VersaPlayer) {
        debugPrint("[play callback] playbackWillBegin")
    }
    
    func playbackReady(player: VersaPlayer) {
        debugPrint("[play callback] playbackReady")
    }
    
    func playbackDidBegin(player: VersaPlayer) {
        debugPrint("[play callback] playbackDidBegin")
    }
    
    func playbackDidEnd(player: VersaPlayer) {
        debugPrint("[play callback] playbackDidEnd")
    }
    
    func startBuffering(player: VersaPlayer) {
        debugPrint("[play callback] startBuffering")
    }
    
    func endBuffering(player: VersaPlayer) {
        debugPrint("[play callback] endBuffering")
        indicatorView.stopAnimating()
    }
    
    func playbackDidFailed(with error: VersaPlayerPlaybackError) {
        debugPrint("[play callback] playbackDidFailed")
        
        indicatorView.stopAnimating()
        let toast = Toast(text: "Play error.")
        toast.show()
        toast.view.useSafeAreaForBottomOffset = true
        toast.view.bottomOffsetPortrait = 300
        toast.view.font = UIFont.systemFont(ofSize: 18)
        self.controls.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            toast.cancel()
            self.navigationController?.popViewController(animated: true)
        }
    }

    func playbackWillPause(player: VersaPlayer) {
        debugPrint("[play callback] playbackWillPause")
    }

    func playbackDidPause(player: VersaPlayer) {
        debugPrint("[play callback] playbackDidPause")
    }

    func playbackItemReady(player: VersaPlayer, item: VersaPlayerItem?) {
        debugPrint("[play callback] playbackItemReady")
        indicatorView.stopAnimating()
    }
}
*/
