//
//  StationsViewController.swift
//  SwiftRadio
//
//  Created by Fethi El Hassasna on 2023-06-24.
//  Copyright © 2023 matthewfecher.com. All rights reserved.
//

import UIKit
import MJRefresh

protocol StationsViewControllerDelegate: AnyObject {
    func pushNowPlayingController(_ stationsViewController: StationsViewController, newStation: Bool)
}

class StationsViewController: BaseController {
    
    var loadPage: Int = 2 // 从1开始
    // MARK: - Delegate
    weak var delegate: StationsViewControllerDelegate?
    
    // MARK: - Properties
    private let player = FRadioPlayer.shared
    private let manager = StationsManager.shared
    
//    let stationBtn: UIButton = {
//        let stationBtn = UIButton(type: .custom)
//        return stationBtn
//    }()
//
    // MARK: - UI
    
//    private lazy var refreshControl: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
//        return refreshControl
//    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = true
        return controller
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        tableView.separatorStyle = .none
        let cellNib = UINib(nibName: "NothingFoundCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "NothingFound")
        tableView.register(StationTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(refresh))
        return tableView
    }()
    
    private let nowPlayingView: NowPlayingView = {
        return NowPlayingView()
    }()
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.isNavigationBarHidden = true
                
        // Setup Player
        player.addObserver(self)
        manager.addObserver(self)
        
        // Now Playing View
        nowPlayingView.tapHandler = { [weak self] in
            self?.nowPlayingBarButtonPressed()
        }
//
//        stationBtn.setTitle("Default Station" + " ▼", for: .normal)
////        stationBtn.setTitle("默认站点" + " ▼", for: .normal)
//        stationBtn.addTarget(self, action: #selector(handleStationTap), for: .touchUpInside)
////        self.navigationController?.navigationBar.addSubview(stationBtn)
//
//        if let firstNavVC = self.tabBarController?.viewControllers?.first?.navigationController {
//            firstNavVC.navigationBar.addSubview(stationBtn)
//        }
//
//        stationBtn.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.equalTo(200)
//            make.height.equalTo(30)
//        }
    }
    
    @objc func handleStationTap(sender: UIButton) {
//        let stations = StationDataManager.shared.loadStations()
//        var stationNames = stations.map { $0.name }
//        stationNames.append("站点管理")
//        let menu = DropDownMenuView.pullDropDrownMenu(anchorView: sender, titleArray: stationNames)
//        menu.selectionAction = { (index: Index, str: String) -> (Void) in
//            if index < stationNames.count-1 {
////                self.collectionVC.refreshVideos(station: self.stations[index])
//                sender.setTitle(str + " ▼", for: .normal)
//            } else {
//                self.navigationController?.pushViewController(StationMgrViewController(), animated: true)
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        stationBtn.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        stationBtn.isHidden = true
    }
    
    @objc func refresh(sender: AnyObject) {
        // Pull to Refresh
        manager.fetch(loadMore: true, loadPage: loadPage) { [weak self] _ in
            self?.tableView.mj_footer?.endRefreshing()
            self?.loadPage += 1
        }
//
//        // Wait 2 seconds then refresh screen
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
//            self?.refreshControl.endRefreshing()
//            self?.view.setNeedsDisplay()
//        }
    }
    
    // Reset all properties to default
    private func resetCurrentStation() {
        nowPlayingView.reset()
        navigationItem.rightBarButtonItem = nil
    }
    
    // Update the now playing button title
    private func updateNowPlayingButton(station: RadioStation?) {
        
        guard let station = station else {
            nowPlayingView.reset()
            return
        }
        
        var playingTitle: String?
        
        if player.currentMetadata != nil {
            playingTitle = station.trackName + " - " + station.artistName
        }
        
        nowPlayingView.update(with: playingTitle, subtitle: station.name)
        createNowPlayingBarButton()
    }
    
    func startNowPlayingAnimation(_ animate: Bool) {
        animate ? nowPlayingView.startAnimating() : nowPlayingView.stopAnimating()
    }
    
    private func createNowPlayingBarButton() {
        guard navigationItem.rightBarButtonItem == nil else { return }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "btn-nowPlaying"), style: .plain, target: self, action: #selector(nowPlayingBarButtonPressed))
    }
    
    @objc func nowPlayingBarButtonPressed() {
        pushNowPlayingController()
    }
        
    func nowPlayingPressed(_ sender: UIButton) {
        pushNowPlayingController()
    }
    
    func pushNowPlayingController(with station: RadioStation? = nil) {
        title = ""
        
        let newStation: Bool
        
        if let station = station {
            // User clicked on row, load/reset station
            newStation = station != manager.currentStation
            if newStation {
                manager.set(station: station)
            }
        } else {
            // User clicked on Now Playing button
            newStation = false
        }
        
        delegate?.pushNowPlayingController(self, newStation: newStation)
    }
    
    override func setupViews() {
        super.setupViews()
        
        let stackView = UIStackView(arrangedSubviews: [tableView, nowPlayingView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
//        tableView.addSubview(refreshControl)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

// MARK: - TableViewDataSource

extension StationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return manager.searchedStations.count
        } else {
            return manager.stations.isEmpty ? 1 : manager.stations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if manager.stations.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NothingFound", for: indexPath)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath) as StationTableViewCell
            
            // alternate background color
            cell.backgroundColor = (indexPath.row % 2 == 0) ? .clear : .black.withAlphaComponent(0.2)
            
            let station = searchController.isActive ? manager.searchedStations[indexPath.row] : manager.stations[indexPath.row]
            cell.configureStationCell(station: station)
            return cell
        }
    }
}

// MARK: - TableViewDelegate

extension StationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let station = searchController.isActive ? manager.searchedStations[indexPath.item] : manager.stations[indexPath.item]
        
        pushNowPlayingController(with: station)
    }
}

// MARK: - FRadioPlayerObserver

extension StationsViewController: FRadioPlayerObserver {
    
    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlayer.PlaybackState) {
        startNowPlayingAnimation(player.isPlaying)
    }
    
    func radioPlayer(_ player: FRadioPlayer, metadataDidChange metadata: FRadioPlayer.Metadata?) {
        updateNowPlayingButton(station: manager.currentStation)
    }
}

extension StationsViewController: StationsManagerObserver {
    
    func stationsManager(_ manager: StationsManager, stationsDidUpdate stations: [RadioStation]) {
        tableView.reloadData()
    }
    
    func stationsManager(_ manager: StationsManager, stationDidChange station: RadioStation?) {
        guard let station = station else {
            resetCurrentStation()
            return
        }
        
        updateNowPlayingButton(station: station)
    }
}
