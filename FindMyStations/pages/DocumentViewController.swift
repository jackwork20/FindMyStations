//
//  PhotoTransportViewController.swift
//  MoviePlayer
//
//  Created by jack on 2023/9/6.
//

import Foundation
import AVFoundation
import AVKit

class DocumentViewController: BaseCollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.title = "File Station"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Import",
                                                                style: .plain, target: self,
                                                                action: #selector(rightButtonOnClick))
    }
    
    override func handleImport() {
        openDocVideoPicker()
    }
    
    @objc func rightButtonOnClick() {
        openDocVideoPicker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}


// MARK: 从File中获取视频
extension DocumentViewController: UIDocumentPickerDelegate {
    func openDocVideoPicker() {
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.movie"], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle(rawValue: 2)!
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let videoURL = urls.first else { return }
        // 在这里处理选中的视频文件，例如播放或下载
        let destPath = (self.rootPath as NSString).appendingPathComponent(videoURL.lastPathComponent)
        _ = FileManager.default.secureCopyItem(at: videoURL, to: URL(fileURLWithPath: destPath))
        
        self.refreshVideos()
    }
}

