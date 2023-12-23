//
//  DataManager.swift
//  Swift Radio
//
//  Created by Matthew Fecher on 3/24/15.
//  Copyright (c) 2015 MatthewFecher.com. All rights reserved.
//

import UIKit

enum DataError: Error {
    case urlNotValid, dataNotValid, dataNotFound, fileNotFound, httpResponseNotValid
}

typealias StationsResult = Result<[RadioStation], Error>
typealias StationsCompletion = (StationsResult) -> Void

struct DataManager {
    
    // Helper struct to get either local or remote JSON
    
    static func getStation(loadMore: Bool, loadPage: Int, completion: @escaping StationsCompletion) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            if Config.useLocalStations {
                loadLocal() { dataResult in
                    handle(dataResult, completion)
                }
            } else {
                loadHttp(loadMore: loadMore, loadPage: loadPage) { dataResult in
                    handle(dataResult, completion)
                }
            }
        }
    }
    
    private typealias DataResult = Result<Data?, Error>
    private typealias DataCompletion = (DataResult) -> Void
    
    private static func handle(_ dataResult: DataResult, _ completion: @escaping StationsCompletion) {
        DispatchQueue.main.async {
            switch dataResult {
            case .success(let data):
//                let result = decode(data)
                let result = decodeRoyalty(data)
                completion(result)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private static func decodeRoyalty(_ data: Data?) -> Result<[RadioStation], Error> {
        if Config.debugLog { print("Stations JSON Found") }
        
        guard let data = data else {
            return .failure(DataError.dataNotFound)
        }
        
        guard let stations = self.handleHtmlResponse(data: data) else {
            return .failure(DataError.dataNotValid)
        }
        
        return .success(stations)
    }
    
    private static func decode(_ data: Data?) -> Result<[RadioStation], Error> {
        if Config.debugLog { print("Stations JSON Found") }
        
        guard let data = data else {
            return .failure(DataError.dataNotFound)
        }

        
        let jsonDictionary: [String: [RadioStation]]
        
        do {
            jsonDictionary = try JSONDecoder().decode([String: [RadioStation]].self, from: data)
        } catch let error {
            return .failure(error)
        }
        
        guard let stations = jsonDictionary["station"] else {
            return .failure(DataError.dataNotValid)
        }
        
        return .success(stations)
    }
    
    // Load local JSON Data
    
    private static func loadLocal(_ completion: DataCompletion) {
        guard let filePathURL = Bundle.main.url(forResource: "stations", withExtension: "json") else {
            if Config.debugLog { print("The local JSON file could not be found") }
            completion(.failure(DataError.fileNotFound))
            return
        }
        
        do {
            let data = try Data(contentsOf: filePathURL, options: .uncached)
            completion(.success(data))
        } catch let error {
            completion(.failure(error))
        }
    }
        
    // Load http JSON Data
    private static func loadHttp(loadMore: Bool, loadPage: Int, _ completion: @escaping DataCompletion) {
        guard let url = URL(string: Config.stationsURL) else {
            if Config.debugLog { print("stationsURL not a valid URL") }
            completion(.failure(DataError.urlNotValid))
            return
        }
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        let session = URLSession(configuration: config)
        
        
        var newUrl = url
        if loadMore {
            if loadPage > 1 {
                newUrl = URL(string: Config.stationsURL + "/\(loadPage)")!
            }
        }
        
        // Use URLSession to get data from an NSURL
        let loadDataTask = session.dataTask(with: newUrl) { data, response, error in
            
            if let error = error {
                if Config.debugLog { print("API ERROR: \(error.localizedDescription)") }
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                if Config.debugLog { print("API: HTTP status code has unexpected value") }
                completion(.failure(DataError.httpResponseNotValid))
                return
            }
            
            guard let data = data else {
                if Config.debugLog { print("API: No data received") }
                completion(.failure(DataError.dataNotFound))
                return
            }
            
            completion(.success(data))
        }
        
        loadDataTask.resume()
    }
}

extension DataManager {
    private static func loadRoyalty(_ completion: @escaping (([RadioStation]?) -> Void)) {
        if let url = URL(string: "https://www.bensound.com/royalty-free-music/cinematic/2") {
            fetchHTML(from: url) { htmlString in
                if let htmlString = htmlString {
                    
                    var newString = htmlString.replacingOccurrences(of: "&amp;", with: "")
                    newString = newString.replacingOccurrences(of: #"&"#, with: "")
                    newString = newString.replacingOccurrences(of: "&", with: "")

                    if let value = self.extractScriptVariableValue(from: newString, variableName: "amplitudeSongs") {
                        let radioList = self.parseJSONString(jsonString: value)
                        completion(radioList)
                        return
                    }
                } else {
                    print("Failed to fetch HTML")
                }
            }
        }
        completion(nil)
    }
    
    private static func handleHtmlResponse(data: Data?) -> [RadioStation]? {
        if let data = data, let htmlString = String(data: data, encoding: .utf8) {
            if let value = self.extractScriptVariableValue(from: htmlString, variableName: "amplitudeSongs") {
                let radioList = self.parseJSONString(jsonString: value)
                return radioList
            }
        } else {
            print("Failed to fetch HTML")
        }
        return nil
    }
    
    private static func parseJSONString(jsonString: String) -> [RadioStation]? {
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: .fragmentsAllowed) as? [Any] {
                    // 在这里处理解析后的 JSON 数据
                    debugPrint(json)
                    
                    var radioList: [RadioStation] = []
                    
                    for dictionary in json {
                        if let dict = dictionary as? [String: Any] {
                            if let name = dict["name"] as? String, let streamURL = dict["url"] as? String, let imageURL = dict["cover_art_url"] as? String, let desc = dict["artist"] as? String {
                                let radio = RadioStation.init(name: name, streamURL: streamURL, imageURL: imageURL, desc: desc)
                                radioList.append(radio)
                            }
                        }
                    }
                    return radioList
                }
            } catch {
                debugPrint("Error: \(error)")
            }
        }
        return nil
    }
    
    
    static func extractScriptVariableValue(from htmlString: String, variableName: String) -> String? {
        let pattern = "\(variableName)\\s*=\\s*(.*?);"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: htmlString.utf16.count)
            
            if let match = regex.firstMatch(in: htmlString, options: [], range: range) {
                let valueRange = match.range(at: 1)
                if let valueRange = Range(valueRange, in: htmlString) {
                    var value = String(htmlString[valueRange])
                    value = value.replacingOccurrences(of: "\\", with: "")
                    return value
                }
            }
        } catch {
            print("Error: \(error)")
        }
        
        return nil
    }
    
    
    private static func fetchHTML(from url: URL, completion: @escaping (String?) -> Void) {
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
