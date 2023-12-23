//
//  RadioViewController.swift
//  MoviePlayer
//
//  Created by jack on 2023/9/23.
//

import Foundation
import MediaPlayer

var coordinator: MainCoordinator?

class RadioViewController: UIViewController {
        
    let navigationVC: UINavigationController
    init(navigationVC: UINavigationController) {
        self.navigationVC = navigationVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FRadioPlayer.shared.isAutoPlay = true
        FRadioPlayer.shared.enableArtwork = true
        
        activateAudioSession()
        
        coordinator = MainCoordinator(navigationController: self.navigationVC, homeVC: self)
        
        coordinator?.start()
    }
}
extension RadioViewController {
    private func activateAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            if Config.debugLog {
                print("audioSession could not be activated: \(error.localizedDescription)")
            }
        }
    }
}
