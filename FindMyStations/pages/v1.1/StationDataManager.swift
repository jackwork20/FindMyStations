//
//  StationDataManager.swift
//  MoviePlayer
//
//  Created by jack on 2023/9/22.
//

import Foundation

enum StationType: Int {
    case inner = 0 // 内置站点，内置站点不允许删除
    case custom // 自定义站点，自定义站点有数量限制
}

/// 资源
struct ResItem {
    /// 资源名称
    let name: String
    /// 资源路径
    let href: String
}

struct MovieInfo: Codable {
    let imgSrc: String
    let title: String
    let href: String
    let isDirect: Bool // 是否可以直接播放
    init(imgSrc: String, title: String, href: String, isDirect: Bool = false) {
        self.imgSrc = imgSrc
        self.title = title
        self.href = href
        self.isDirect = isDirect
    }
}

struct MovieInfoMgr {
    static let shared = MovieInfoMgr()
    
    func parse(jsonString: String) -> [MovieInfo]? {
        let jsondata = jsonString.data(using: .utf8)
        return try? JSONDecoder().decode([MovieInfo].self, from: jsondata!)
    }
    
    func convert(moveInfo: [MovieInfo]) -> String? {
        do {
            let result = try JSONEncoder().encode(moveInfo)
            guard let json = String(data: result, encoding: .utf8) else { return nil }
            return json
        } catch {
            debugPrint("error: \(error)")
        }
        return nil
    }
}


struct Station: Codable {
    let type: StationType
    /// 站点名称
    let name: String
    var jsonContent: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try StationType(rawValue: container.decode(StationType.RawValue.self, forKey: .type))!
        self.name = try container.decode(String.self, forKey: .name)
        self.jsonContent = try container.decodeIfPresent(String.self, forKey: .jsonContent)
    }
    
    enum CodingKeys: CodingKey {
        case type
        case name
        case jsonContent
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.type.rawValue, forKey: .type)
        try container.encode(self.name, forKey: .name)
        try container.encodeIfPresent(self.jsonContent, forKey: .jsonContent)
    }
    
    init(name: String, type: StationType, jsonContent: String? = nil) {
        self.name = name
        self.type = type
        self.jsonContent = jsonContent
    }
}

let defaultStation = Station(name: defaultStationDesc, type: .inner)
let photoStation = Station(name: photoStationDesc, type: .inner)
let fileStation = Station(name: fileStationDesc, type: .inner)

class StationDataManager {
    static let shared = StationDataManager()
    
    var stations: [Station] = []
    
    init() {
        self.stations += loadStations()
    }
    
    func reloadStation() {
        self.stations = loadStations()
    }
    
    let videoStationPath = StationPath.videoStationConfig.getPath()
    
    // 读取所有站点信息
    func getDefaultStations() -> [Station] {
        [defaultStation, photoStation, fileStation]
    }
    
    // 新增站点
    func appendStation(station: Station) {
        self.stations.append(station)
    }
    
    func updateStation(station: Station) {
        if let index = self.stations.firstIndex(where: { $0.name == station.name }) {
            self.stations[index] = station
        } else {
            self.appendStation(station: station)
        }
    }
    
    func save() {
        let jsonString = self.convert(stations: self.stations)
        try? jsonString.write(toFile: videoStationPath, atomically: true, encoding: .utf8)
    }
    
    // 解析json文件
    func loadStations() -> [Station] {
        let path = videoStationPath
        do {
            let dataString = try String(contentsOfFile: path, encoding: .utf8)
            let jsondata = dataString.data(using: .utf8)
            let result = try JSONDecoder().decode([Station].self, from: jsondata!)
            return result
        } catch {
            debugPrint("---\(error)")
        }
        return self.getDefaultStations()
    }
    
    // 转换struct为json文件
    func convert(stations: [Station]) -> String {
        do {
            let result = try JSONEncoder().encode(stations)
            guard let json = String(data: result, encoding: .utf8) else { return "" }
            return json
        } catch {
            debugPrint("---\(error)")
        }
        return ""
    }
}
