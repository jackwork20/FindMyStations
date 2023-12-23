//
//  MenuViewController.swift
//  MoviePlayer
//
//  Created by jack on 2023/8/20.
//

import Foundation

struct BaseTableCellItem {
    let title: String
    let action: (() -> Void)
    let switchAction: ((_ on: Bool) -> Void)?
    init(title: String, action: @escaping () -> Void, switchAction: ( (_: Bool) -> Void)? = nil) {
        self.title = title
        self.action = action
        self.switchAction = switchAction
    }
    
}

struct BaseTableSectionItem {
    let section: String
    let cellItems: [BaseTableCellItem]
}

class BaseTableViewController: UIViewController {
    var data: [BaseTableSectionItem] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        self.tableView.backgroundColor = .clear
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        let colors: [CGColor] = [UIColor(red: 19/255.0, green: 41/255.0, blue: 75/255.0, alpha: 1).cgColor,
                                 UIColor(red: 5/255.0, green: 12/255.0, blue: 23/255.0, alpha: 1).cgColor]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension BaseTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem: BaseTableSectionItem = self.data[section]
        return sectionItem.cellItems.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let sectionItem: BaseTableSectionItem = self.data[section]
//        return sectionItem.section
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.backgroundColor = UIColorFromRGB(rgbValue: 0x0D2C5B)
        cell.backgroundColor = UIColor(rgb: 0xffffff, alpha: 0.1)
        let sectionItem: BaseTableSectionItem = self.data[indexPath.section]
        let cellItem: BaseTableCellItem = sectionItem.cellItems[indexPath.row]
        cell.textLabel?.text = cellItem.title
        cell.textLabel?.textColor = .white
        if cellItem.switchAction == nil {
            cell.accessoryType = .disclosureIndicator
        } else {
            // 采用switch
            let switchView = UISwitch(frame: CGRectMake(0, 0, 60, 40))
            switchView.tag = indexPath.section * 1000 + indexPath.row * 10 + 10000
            switchView.addTarget(self, action: #selector(onSwitchChanged), for: .valueChanged)
            cell.accessoryView = switchView
        }
        return cell
    }
    
    @objc func onSwitchChanged(switchView: UISwitch) {
        let section: Int = (switchView.tag - 10000) / 1000
        let row: Int = (switchView.tag - 10000 - section * 1000) / 10
        
        let sectionItem: BaseTableSectionItem = self.data[section]
        let cellItem: BaseTableCellItem = sectionItem.cellItems[row]
        cellItem.switchAction?(switchView.isOn)
    }
}

extension BaseTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let sectionItem: BaseTableSectionItem = self.data[indexPath.section]
        let cellItem: BaseTableCellItem = sectionItem.cellItems[indexPath.row]
        
        cellItem.action()
    }
}
