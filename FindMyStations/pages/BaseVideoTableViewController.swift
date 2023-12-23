//
//  BaseVideoTableViewController.swift
//  MoviePlayer
//
//  Created by jack on 2023/9/17.
//

import Foundation

class BaseVideoTableViewController: UIViewController {
    
    let rootPath: String
    init(rootPath: String) {
        self.rootPath = rootPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var videos: [VideoItem] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
}

extension BaseVideoTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let videoItem = self.videos[indexPath.row]
        cell.imageView?.image = videoItem.image
        cell.textLabel?.text = videoItem.name
        cell.detailTextLabel?.text = String(videoItem.duration)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension BaseVideoTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(PlayerViewController(self.videos[indexPath.row]), animated: true)
    }
}
