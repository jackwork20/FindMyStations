//
//  VideoHelper.swift
//  MoviePlayer
//
//  Created by jack on 2023/9/7.
//

import Foundation
import AVFoundation

func imageToBase64(image: UIImage) -> String? {
    guard let imageData = image.jpegData(compressionQuality: 1.0) else { return nil }
    return imageData.base64EncodedString(options: [])
}

func base64ToImage(base64String: String) -> UIImage? {
    guard let data = Data(base64Encoded: base64String) else { return nil }
    return UIImage(data: data)
}

extension UIImage {
    func base64() -> String {
        return imageToBase64(image: self) ?? ""
    }
}

// 视频文件类
struct VideoItem: Encodable, Decodable {
    let name: String
    let size: Int64
    let duration: TimeInterval
    let imageBase64: String?
    let href: String
    
    var image: UIImage? {
        guard let imageBase64 = imageBase64 else {
            return nil
        }
        guard let imageData = Data(base64Encoded: imageBase64, options: .ignoreUnknownCharacters) else {
            return nil
        }
        let image = UIImage(data: imageData)
        return image
    }
    
//    var imageData: Data? {
//        return image?.pngData()
//    }
//
//    var imageBase64: String? {
//        return imageData?.base64EncodedString(options: .lineLength64Characters)
//    }
    
    init(name: String, size: Int64, duration: TimeInterval, imageBase64: String?, href: String) {
        self.name = name
        self.size = size
        self.duration = duration
        self.imageBase64 = imageBase64
        self.href = href
    }
      
//    init(name: String, size: Int64, duration: TimeInterval, imageBase64: String?, href: String) {
//        self.name = name
//        self.size = size
//        self.duration = duration
//        self.href = href
//
//        if let imageBase64 = imageBase64, let imageData = Data(base64Encoded: imageBase64, options: .ignoreUnknownCharacters), let image = UIImage(data: imageData) {
//            self.image = image
//        } else {
//            self.image = nil
//        }
//    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case age
        case size
        case duration
        case imageBase64
        case href
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(size, forKey: .size)
        try container.encode(duration, forKey: .duration)
        try container.encode(imageBase64, forKey: .imageBase64)
        try container.encode(href, forKey: .href)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        size = try container.decode(Int64.self, forKey: .size)
        duration = try container.decode(TimeInterval.self, forKey: .duration)
        self.imageBase64 = try container.decodeIfPresent(String.self, forKey: .imageBase64)
        href = try container.decode(String.self, forKey: .href)
    }
}


struct VideoHelper {
    /// 递归遍历目录中的所有文件
    /// - Parameter path: 目录路径
    /// - Returns: 所有文件名
    
    static func getAllFilePath(_ dirPath: String) -> [String]? {
        var filePaths = [String]()
        do {
            let array = try FileManager.default.contentsOfDirectory(atPath: dirPath)
            for fileName in array {
                var isDir: ObjCBool = true
                let fullPath = "\(dirPath)/\(fileName)"
                if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir) {
                    if !isDir.boolValue {
                        let pathExtension = (fullPath as NSString).pathExtension.lowercased()
                        if pathExtension == "mp4"
                            || pathExtension == "mov"
                            || pathExtension == "m4v" {
                            filePaths.append(fullPath)
                        }
                    } else {
                        filePaths.append(contentsOf: getAllFilePath(fullPath) ?? [])
                    }
                }
            }
        } catch let error as NSError {
            print("get file path error: \(error)")
        }
        return filePaths
    }
    
    static func getAllVideos(_ dirPath: String) -> [VideoItem] {
        guard let fileList = self.getAllFilePath(dirPath) else {
            return []
        }
        return fileList.map { path in
            let url = URL(fileURLWithPath: path)
            let asset = AVAsset(url: url)
            let duration = asset.duration.value
            let size = 0
            let name = url.lastPathComponent
            let thumbnailTime = CMTimeMakeWithSeconds(1.0, preferredTimescale: 30)
            let image = getVideoThumbnail(from: asset, atTime: thumbnailTime)
            return VideoItem(name: name, size: Int64(size), duration: Double(duration), imageBase64: image?.base64(), href: url.absoluteString)
        } as! [VideoItem]
    }

    
    // 获取指定目录下的所有视频文件
    static func getVideoFiles(atPath path: String) -> [VideoItem] {
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(atPath: path)
        var videoFiles: [VideoItem] = []
        while let fileName = enumerator?.nextObject() as? String {
            let filePath = (path as NSString).appendingPathComponent(fileName)
            let item = URL(fileURLWithPath: filePath)
            if item.pathExtension.lowercased() == "mp4"
                || item.pathExtension.lowercased() == "mov"
                || item.pathExtension.lowercased() == "m4v" {
                let asset = AVAsset(url: item)
                let duration = asset.duration.value
                let size = 0
                let name = item.lastPathComponent
                let thumbnailTime = CMTimeMakeWithSeconds(1.0, preferredTimescale: 30)
                let image = getVideoThumbnail(from: asset, atTime: thumbnailTime)
                videoFiles.append(VideoItem(name: name, size: Int64(size), duration: Double(duration), imageBase64: image?.base64(), href: item.absoluteString))
            }
        }
        return videoFiles
    }
    
    static func getVideoThumbnail(from asset: AVAsset, atTime time: CMTime) -> UIImage? {
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch {
            print("Error generating video thumbnail: (error)")
            return nil
        }
    }

}
