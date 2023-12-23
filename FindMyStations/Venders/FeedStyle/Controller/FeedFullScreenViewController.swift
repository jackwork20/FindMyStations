//
//  FeedFullScreenViewController.swift
//  FindMyStations
//
//  Created by jack on 2023/10/29.
//

import Foundation

/// 全屏窗口
class FeedFullScreenViewController: UIViewController, SuperPlayerDelegate {
    // 视频窗口    
    var playerView: SuperPlayerView? {
        didSet {
            playerView?.delegate = self
            playerView?.fatherView = faterView
            if let playerView = playerView {
                faterView.addSubview(playerView)
                playerView.snp.makeConstraints { make in
                    make.edges.equalTo(faterView)
                }
            }
        }
    }
    
    lazy var faterView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppOrientation.interfaceOrientationMask = .landscapeRight
        _ = movRotate(to: .landscapeRight)
        movSetNeedsUpdateOfSupportedInterfaceOrientations()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppOrientation.interfaceOrientationMask = .portrait
        _ = movRotate(to: .portrait)
        movSetNeedsUpdateOfSupportedInterfaceOrientations()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.view.addSubview(self.faterView)
        self.faterView.snp.makeConstraints { make in
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            make.top.bottom.equalToSuperview()
        }
    }

    func superPlayerFullScreenChanged(_ player: SuperPlayerView) {
        if player.isFullScreen {
            player.disableGesture = true
            player.showOrHideBackBtn(true)
        } else {
            player.disableGesture = false
            player.showOrHideBackBtn(false)
        }
    }

    func backHookAction() {
        navigationController?.popViewController(animated: false)
    }

    func movRotate(to interfaceOrientation: UIInterfaceOrientation) -> Bool {
        return self.smovRotate(to: interfaceOrientation)
//        if #available(iOS 16.0, *) {
//            setNeedsUpdateOfSupportedInterfaceOrientations()
//            var result = true
//            let mask = UIInterfaceOrientationMask(rawValue: 1 << interfaceOrientation.rawValue)
//            let window = self.view.window ?? currentWindow()
//            window?.windowScene?.requestGeometryUpdate(UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: mask)) { error in
//                result = error != nil
//            }
//            return result
//        } else {
//            let orientationUnknown = UIInterfaceOrientation.unknown
//            UIDevice.current.setValue(NSNumber(value: orientationUnknown.rawValue), forKey: "orientation")
//            UIDevice.current.setValue(NSNumber(value: interfaceOrientation.rawValue), forKey: "orientation")
//            // 延时一下调用，否则无法横屏
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//                FeedFullScreenViewController.attemptRotationToDeviceOrientation()
//            }
//            return true
//        }
    }

    func currentWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene })
        for scene in connectedScenes {
            let windows = scene.windows
            if windows.count > 0 {
                return windows[0]
            }
        }
        return nil
    }

    func movSetNeedsUpdateOfSupportedInterfaceOrientations() {
        self.smovSetNeedsUpdateOfSupportedInterfaceOrientations()
//        if #available(iOS 16.0, *) {
//            DispatchQueue.main.async {
//                self.setNeedsUpdateOfSupportedInterfaceOrientations()
//            }
//        } else {
//            DispatchQueue.main.async { [weak self] in
//                let supportedInterfaceSelector = NSSelectorFromString("setNeedsUpdateOfSupportedInterfaceOrientations")
//                self?.perform(supportedInterfaceSelector)
//            }
//        }
    }
}

extension FeedStylePlayViewController: SuperPlayerDelegate {
}
