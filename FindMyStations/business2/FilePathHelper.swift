//
//  FilePathHelper.swift
//  MoviePlayer
//
//  Created by jack on 2023/9/14.
//

import Foundation

// 所有文件都存放在Documents/files目录下
enum FilePath: String {
    case cache = "config"
    case home = "files"
    case photo = "files/photo"
    case doc = "files/doc"
    case wifi = "files/wifi"
    case url = "files/url"
    
    func getDirPath() -> String {
        let homePath = (NSHomeDirectory() as NSString).appendingPathComponent("Documents")
        let path = (homePath as NSString).appendingPathComponent(self.rawValue) as String
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
            } catch {
                debugPrint("--\(error)")
            }
        }
        return path
    }
}

enum StationPath: String {
    case parentDir = "config"
    case videoStationConfig = "config/video_station.json"
    
    func getPath() -> String {
        let homePath = (NSHomeDirectory() as NSString).appendingPathComponent("Documents")
        let parentDir = (homePath as NSString).appendingPathComponent(StationPath.parentDir.rawValue) as String
        
        if !FileManager.default.fileExists(atPath: parentDir) {
            do {
                try FileManager.default.createDirectory(atPath: parentDir, withIntermediateDirectories: true)
            } catch {
                debugPrint("--\(error)")
            }
        }
        return (homePath as NSString).appendingPathComponent(self.rawValue)
    }
}

struct FilePathHelper {
    
}
