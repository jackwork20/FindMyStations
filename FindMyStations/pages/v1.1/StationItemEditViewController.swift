////
////  StationItemEditViewController.swift
////  MoviePlayer
////
////  Created by jack on 2023/9/22.
////
//
//import Foundation
//
///// 通过资源条目方式导入
//class StationItemEditViewController: UIViewController {
//    let station: Station
//    init(station: Station) {
//        self.station = station
//        super.init(nibName: nil, bundle: nil)
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    let rootLayout = TGLinearLayout(.vert)
//    let addBtn = UIButton(type: .custom)
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.title = station.name
//        
//        rootLayout.tg_width.equal(.fill)
//        rootLayout.tg_height.equal(.fill)
//        rootLayout.tg_space = 12
//        let textFiled = newTextField()
//        rootLayout.addSubview(textFiled)
//        textFiled.text = station.name
//        
////        if let resList = station.resList {
////            for resItem in resList {
////                let itemField = newTextField()
////                rootLayout.addSubview(itemField)
////                itemField.text = resItem.name
////            }
////        }
//        
//        // 添加Add按钮
//        addBtn.setTitle("添加", for: .normal)
//        addBtn.addTarget(self, action: #selector(onAdd), for: .touchUpInside)
//        addBtn.tg_width.equal(.fill)
//        addBtn.tg_height.equal(20)
//        rootLayout.addSubview(addBtn)
//        
//        self.view.addSubview(rootLayout)
//    }
//    
//    @objc func onAdd() {
//        addBtn.removeFromSuperview()
//        let itemField = newTextField()
//        rootLayout.addSubview(itemField)
//        itemField.placeholder = "输入资源名称和路径"
//        rootLayout.addSubview(addBtn)
//    }
//}
//
//extension StationItemEditViewController {
//    func newTextField() -> UITextField {
//        let textFiled = UITextField()
//        textFiled.tg_width.equal(.fill)
//        textFiled.tg_height.equal(30)
//        textFiled.layer.borderWidth = 0.5
//        textFiled.layer.borderColor = UIColor.white.cgColor
//        return textFiled
//    }
//}
