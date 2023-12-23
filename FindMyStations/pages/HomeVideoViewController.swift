////
////  PhotoTransportViewController.swift
////  MoviePlayer
////
////  Created by jack on 2023/9/6.
////
//
//import Foundation
//import AVFoundation
//import AVKit
//
//class HomeVideoViewController: BaseCollectionViewController {
//    override func handleImport() {
//        let alertController = UIAlertController(title: "添加视频", message: "", preferredStyle: .actionSheet)
//        alertController.addAction(UIAlertAction(title: "相册导入", style: .default) { _ in
//            self.navigationController?.pushViewController(PhotoVideoViewController(rootPath: FilePath.photo.getDirPath()), animated: true)
//        })
//        alertController.addAction(UIAlertAction(title: "文件导入", style: .default) { _ in
//            self.navigationController?.pushViewController(DocumentViewController(rootPath: FilePath.doc.getDirPath()), animated: true)
//        })
//        alertController.addAction(UIAlertAction(title: "添加URL", style: .default) { _ in
//            self.navigationController?.pushViewController(URLFavoriteViewController(rootPath: FilePath.url.getDirPath()), animated: true)
//        })
//        alertController.addAction(UIAlertAction(title: "取消", style: .cancel) {_ in
//            
//        })
//        self.present(alertController, animated: true)
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.refreshVideos()
//    }
//}
