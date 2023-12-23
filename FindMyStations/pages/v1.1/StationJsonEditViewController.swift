//
//  StationJsonEditViewController.swift
//  MoviePlayer
//
//  Created by jack on 2023/9/22.
//

import Foundation

/// 通过json方式导入
class StationJsonEditViewController: UIViewController {
    var station: Station
    init(station: Station) {
        self.station = station
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let textView = XTextViewPlaceholder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = station.name
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(onSave))
        
        self.view.addSubview(textView)
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().offset(0)
            make.top.equalTo(20)
            make.bottom.equalToSuperview()
        }
        textView.placeholderColor = UIColor(rgb: 0xffffff, alpha: 0.3)
        if station.name == defaultStationDesc {
            textView.placeholder = "[{\"title\": \"如何添加站点\",\"imgSrc\": \"$SRC/demo.png\",\"href\": \"$SRC/How_To_Use.mp4\"}]"
        } else {
            textView.placeholder = "通过json方式导入，可在PC上编辑后粘贴到文本框中"
        }
        
        textView.text = station.jsonContent ?? ""
        textView.backgroundColor = .clear
        textView.textColor = .white
        
        let colors: [CGColor] = [UIColor(red: 19/255.0, green: 41/255.0, blue: 75/255.0, alpha: 1).cgColor,
                                 UIColor(red: 5/255.0, green: 12/255.0, blue: 23/255.0, alpha: 1).cgColor]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.textView.text.count == 0 {
            textView.becomeFirstResponder()
        }
    }
    
    @objc func onSave() {
        station.jsonContent = textView.text.replacingOccurrences(of: "\n", with: "")
        StationDataManager.shared.appendStation(station: station)
        StationDataManager.shared.save()
        self.navigationController?.popViewController(animated: true)
    }
}
