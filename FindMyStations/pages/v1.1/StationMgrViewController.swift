//
//  StationManagerViewController.swift
//  MoviePlayer
//
//  Created by jack on 2023/9/22.
//

import Foundation

/// 站点管理页面
class StationMgrViewController: BaseTableViewController {
    
    let stationDataMgr = StationDataManager.shared
    let addBtn = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  stationManagerDesc //"站点管理"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: editText, style: .plain, target: self, action: #selector(onTapManager))
        
        let stations = stationDataMgr.loadStations()
        let cellItems = stations.map { station in
            return BaseTableCellItem(title: station.name) {
                if station.name != photoStationDesc && station.name != fileStationDesc {
                    self.navigationController?.pushViewController(StationJsonEditViewController(station: station), animated: true)
                } else {
                    let alertController = UIAlertController(title: "", message: "This entry cannot be edited", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alertController, animated: true)
                }
            }
        }
        self.data = [BaseTableSectionItem(section: "Stations List", cellItems: cellItems)]
        
        addBtn.setTitle("Add Station", for: .normal)
        addBtn.addTarget(self, action: #selector(onTapAdd), for: .touchUpInside)
        addBtn.layer.borderColor = UIColor.darkGray.cgColor
        addBtn.layer.borderWidth = 1
        self.view.addSubview(addBtn)
        addBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-50)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(40)
        }
        addBtn.layer.cornerRadius = 20
        
        self.tableView.snp.remakeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(addBtn.snp.top)
        }
    }
    
    @objc func onTapManager() {
        tableView.isEditing = !tableView.isEditing
        self.navigationItem.rightBarButtonItem?.title = tableView.isEditing ? "Finish" : "Edit"
        
        if !tableView.isEditing {
            self.stationDataMgr.save()
        }
    }
    
    @objc func onTapAdd() {
        let alertController = UIAlertController(title: "Add Station", message: "", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "From url", style: .default) { _ in
            
            let alert = UIAlertController(title: "Add url", message: "", preferredStyle: .alert)
            alert.addTextField() {
                $0.placeholder = "Enter the site url here"
//                $0.isSecureTextEntry = true
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                if let text = alert.textFields?.first?.text {
                    self.parseStation(url: text)
                }
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        })
        alertController.addAction(UIAlertAction(title: "Manually add", style: .default) { _ in
            let alert = UIAlertController(title: "Add Station", message: "", preferredStyle: .alert)
            alert.addTextField() {
                $0.placeholder = "Please input station name"
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                if let text = alert.textFields?.first?.text {
                    self.navigationController?.pushViewController(StationJsonEditViewController(station: Station(name: text, type: .custom)), animated: true)
                }
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
            
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) {_ in
            
        })
        self.present(alertController, animated: true)
    }
}

// MARK: 解析并添加站点
extension StationMgrViewController {
    // 解析站点
    func parseStation(url: String) {
        // Toast loading
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = Date()
        var name = dateFormatter.string(from: currentDate)
        if let nsurl = URL(string: url) {
            name = nsurl.host ?? "unknown"
        }
        
        StationVideoParserDef.shared.loadStation(url: url) { movieList in
            let jsonString = MovieInfoMgr.shared.convert(moveInfo: movieList)
            let station = Station(name: name, type: .custom, jsonContent: jsonString)
            StationDataManager.shared.appendStation(station: station)
            StationDataManager.shared.save()
            self.reloadData()
        }
        
        // Toast finished
    }
}

extension StationMgrViewController {
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath == destinationIndexPath {
            return
        }
        self.stationDataMgr.stations.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let section = self.data.first {
                self.stationDataMgr.stations.remove(at: indexPath.row)
                var cellItems = section.cellItems
                cellItems.remove(at: indexPath.row)
                self.data = [BaseTableSectionItem(section: section.section, cellItems: cellItems)]
                
                tableView.reloadData()
            }
        }
    }
}

extension StationMgrViewController {
    func reloadData() {
        stationDataMgr.reloadStation()
        let stations = stationDataMgr.stations
        let cellItems = stations.map { station in
            return BaseTableCellItem(title: station.name) {
                if station.name != photoStationDesc && station.name != fileStationDesc {
                    self.navigationController?.pushViewController(StationJsonEditViewController(station: station), animated: true)
                } else {
                    let alertController = UIAlertController(title: "", message: "This entry cannot be edited", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alertController, animated: true)
                }
            }
        }
        self.data = [BaseTableSectionItem(section: "Stations List", cellItems: cellItems)]
        self.tableView.reloadData()
    }
}
