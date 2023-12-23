//
//  MainCoordinator.swift
//  SwiftRadio
//
//  Created by Fethi El Hassasna on 2022-11-23.
//  Copyright © 2022 matthewfecher.com. All rights reserved.
//

import UIKit

class MainCoordinator: NavigationCoordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    weak var homeVC: UIViewController?
    
    func start() {
        let loaderVC = LoaderController()
        loaderVC.delegate = self
        if let homeVC = self.homeVC {
            homeVC.addChild(loaderVC)
            homeVC.view.addSubview(loaderVC.view)
            loaderVC.didMove(toParent: homeVC)
        }
    }
    
    init(navigationController: UINavigationController, homeVC: UIViewController) {
        self.navigationController = navigationController
        self.homeVC = homeVC
    }
}

// MARK: - LoaderControllerDelegate

extension MainCoordinator: LoaderControllerDelegate {
    func didFinishLoading(_ controller: LoaderController, stations: [RadioStation]) {
        let stationsVC = StationsViewController()
        stationsVC.delegate = self
        if let homeVC = self.homeVC {
            homeVC.addChild(stationsVC)
            homeVC.view.addSubview(stationsVC.view)
            stationsVC.didMove(toParent: homeVC)
        }
    }
}

// MARK: - StationsViewControllerDelegate

extension MainCoordinator: StationsViewControllerDelegate {
    
    func pushNowPlayingController(_ stationsViewController: StationsViewController, newStation: Bool) {
        let nowPlayingController = Storyboard.viewController as NowPlayingViewController
        nowPlayingController.isNewStation = newStation
        navigationController.pushViewController(nowPlayingController, animated: true)
    }
}


