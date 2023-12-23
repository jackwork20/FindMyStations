//
//  FileHelper.swift
//  MoviePlayer
//
//  Created by jack on 2023/9/11.
//

import Foundation

class FileHelper {
    // 拷贝文件
    static func copyFile(origPath: String, destPath: String) -> Bool {
        var bValue = false
        do {
            if FileManager.default.fileExists(atPath: destPath) {
                try FileManager.default.removeItem(atPath: destPath)
            }
            try FileManager.default.copyItem(atPath: origPath, toPath: destPath)
            bValue = true
        } catch {
            debugPrint("\(error)")
        }
        return bValue
    }
}
