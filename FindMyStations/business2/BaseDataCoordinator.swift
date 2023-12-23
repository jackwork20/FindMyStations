//
//  BaseDataCoordinator.swift
//  FindMyStations
//
//  Created by jack on 2023/10/29.
//

import Foundation

protocol BaseDataCoordinator {
    /// 加载数据，获取视频列表
    /// - Parameters:
    ///   - urlString: web网页地址
    ///   - completion: 回调，执行在主线程
    func loadVideos(pageIndex: Int, completion: @escaping ([MovieInfo]) -> Void)
    
    /// 查询下载地址
    /// - Parameters:
    ///   - descUrl: 详情页地址
    ///   - completion: 回调，执行在主线程
    func queryDescInfo(descUrl: String, completion: @escaping (String?) -> Void)
    
    /// 首页的加载地址
    func getStationURL() -> String
    
    /// 获取下一页的url地址
    /// - Parameters:
    ///   - urlStrig: 首页地址/起始url
    ///   - nextPage: 下一个页面编号
    /// - Returns: 新的页面地址
    func getNextPageURL(urlStrig: String, nextPage: Int) -> String
}

extension BaseDataCoordinator {
    func fetchHTML(from url: URL, completion: @escaping (String?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            if let data = data, let htmlString = String(data: data, encoding: .utf8) {
                completion(htmlString)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
}

extension BaseDataCoordinator {
    func extractSubstring(from originalString: String, startStr: String, endStr: String) -> String? {
        guard let startIndex = originalString.range(of: startStr)?.upperBound else {
            return nil
        }
        
        guard let endIndex = originalString.range(of: endStr, range: startIndex..<originalString.endIndex)?.lowerBound else {
            return nil
        }
        
        return String(originalString[startIndex..<endIndex])
    }
}
