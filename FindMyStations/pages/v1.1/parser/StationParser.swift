//
//  StationParser.swift
//  StationPlayer
//
//  Created by jack on 2023/9/26.
//

import Foundation

typealias MyStationsResult = Result<[Station], Error>
typealias MyStationsCompletion = (MyStationsResult) -> Void

protocol StationParser {
    // 加载站点
    func loadStation(url: String, completion: @escaping ([MovieInfo]) -> Void)
}

extension StationParser {
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

// MARK: StationVideoParser
class StationVideoParserDef: StationParser {
    static let shared = StationVideoParserDef()
    
    func loadStation(url: String, completion: @escaping ([MovieInfo]) -> Void) {
        let urlString = url
        if let nsurl = URL(string: urlString) {
            fetchHTML(from: nsurl) { htmlString in
                if let htmlString = htmlString {
                    
                    let doc = TFHpple(htmlData: htmlString.data(using: .utf8))
                    let array = doc?.search(withXPathQuery: "/html/body/div[6]/div[1]/div[2]/ul")
                    
                    var movieList: [MovieInfo] = []
                    
                    if let rootElement = array?[0] as? TFHppleElement {
                        if let childArray = rootElement.children {
                            for element in childArray {
                                if let element = element as? TFHppleElement {
                                    if !element.isTextNode() {
                                        if let xchild = element.children {
                                            for element2 in xchild {
                                                if let element2 = element2 as? TFHppleElement {
                                                    if !element2.isTextNode() {
                                                       if let attributes2 =  element2.attributes as? NSDictionary,
                                                          let href = attributes2["href"] as? String {
                                                           for element3 in element2.children {
                                                               if let element3 = element3 as? TFHppleElement {
                                                                   if !element3.isTextNode() {
                                                                       if let attributes = element3.attributes as? NSDictionary {
                                                                           if let imgUrl = attributes["_src"] as? String,
                                                                              let title = attributes["alt"] as? String {
                                                                               debugPrint("imgUrl: \(imgUrl) title: \(title) href: \(href)")
                                                                               
                                                                               var _imgSrc = imgUrl
                                                                               if imgUrl.hasPrefix("//") {
                                                                                   _imgSrc = "http:" + imgUrl
                                                                               }
                                                                               
                                                                               var _href = href
                                                                               if !href.hasPrefix("http") {
                                                                                   _href = ZXBA_STRING + href
                                                                               }
                                                                               movieList.append(MovieInfo(imgSrc: _imgSrc, title: title, href: _href))
                                                                           }
                                                                       }
                                                                       
                                                                   }
                                                               }
                                                           }
                                                       }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            completion(movieList)
                        }
                    }
                } else {
                    print("Failed to fetch HTML")
                }
            }
        }
    }
}
