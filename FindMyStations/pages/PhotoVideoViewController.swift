//
//  PhotoTransportViewController.swift
//  MoviePlayer
//
//  Created by jack on 2023/9/6.
//

import Foundation
import AVFoundation
import AVKit

class PhotoVideoViewController: BaseCollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.title = "Photo Station"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Import",
                                                                style: .plain, target: self,
                                                                action: #selector(rightButtonOnClick))
    }
    
    override func handleImport() {
        openVideoPicker()
    }
    
    @objc func rightButtonOnClick() {
        openVideoPicker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}


// MARK: 从相册中获取视频
extension PhotoVideoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openVideoPicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = ["public.movie"]
        self.present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            // 在这里处理选中的视频文件，例如播放或下载
            let destPath = (self.rootPath as NSString).appendingPathComponent(videoURL.lastPathComponent)
            _ = FileManager.default.secureCopyItem(at: videoURL, to: URL(fileURLWithPath: destPath))
            
            self.refreshVideos()
            
        } else {
            dismiss(animated: true, completion: nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension FileManager {
    open func secureCopyItem(at srcURL: URL, to dstURL: URL) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: dstURL.path) {
                try FileManager.default.removeItem(at: dstURL)
            }
            try FileManager.default.copyItem(at: srcURL, to: dstURL)
        } catch (let error) {
            print("Cannot copy item at \(srcURL) to \(dstURL): \(error)")
            return false
        }
        return true
    }

}
