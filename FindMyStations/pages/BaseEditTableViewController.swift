////
////  BaseEditTableViewController.swift
////  MoviePlayer
////
////  Created by jack on 2023/9/7.
////
//
//import Foundation
//
///// 支持编辑的tableview，用来支持导入视频的展示
//class BaseEditTableViewController: UIViewController {
//    private lazy var tableView: UITableView = {
//        let tableView = UITableView(frame: .zero, style: .grouped)
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        tableView.delegate = self
//        tableView.dataSource = self
//        return tableView
//    }()
//    
//    private lazy var addBtn: UIButton = {
//        let btn = UIButton(type: .custom)
//        btn.setTitle("添加视频链接", for: .normal)
//        return btn
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.view.addSubview(self.tableView)
//        self.view.addSubview(self.addBtn)
//        
//        self.addBtn.snp.makeConstraints { make in
//            make.left.right.bottom.equalToSuperview()
//            make.height.equalTo(50)
//        }
//        
//        self.tableView.snp.makeConstraints { make in
//            make.left.right.top.equalToSuperview()
//            make.bottom.equalTo(self.addBtn.snp.top)
//        }
//        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "管理", style: .plain, target: self, action: #selector(onManagerClick))
//    }
//    
//    @objc
//    func onManagerClick() {
//        
//    }
//}
//
//extension BaseEditTableViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.accessoryType = .disclosureIndicator
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//}
