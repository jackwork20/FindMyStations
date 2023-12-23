////
////  StationParserDataCoordinator.swift
////  FindMyStations
////
////  Created by jack on 2023/10/29.
////
//
//import Foundation
//
//class StationParserDataCoordinator: BaseDataCoordinator {
//    func loadVideos(pageIndex: Int, completion: @escaping ([MovieInfo]) -> Void) {
//        let urlString = self.getNextPageURL(urlStrig: self.getHomeURL(), nextPage: pageIndex)
//        if let url = URL(string: urlString) {
//            fetchHTML(from: url) { htmlString in
//                if let htmlString = htmlString {
//                    let doc: TFHpple = TFHpple(htmlData: htmlString.data(using: .utf8))!
//                    let xpath = "//*[@id=\"content\"]"
//                    let movieList: [MovieInfo] = self.handleResponse(xpath: xpath, doc: doc)
//                    DispatchQueue.main.async {
//                        completion(movieList)
//                    }
//                }
//            }
//        }
//    }
//    
//    func queryDescInfo(descUrl: String, completion: @escaping (String?) -> Void) {
//        guard let url = URL(string: descUrl) else {
//            completion(nil)
//            return
//        }
//        
//        fetchHTML(from: url) { htmlString in
//            if let htmlString = htmlString {
//                if let value = self.extractSubstring(from: htmlString, startStr: "\"contentUrl\": \"", endStr: "\"") {
//                    DispatchQueue.main.async {
//                        completion(value)
//                    }
//                    return
//                }
//            }
//            
//            // 如果最终没有解析出来，也抛出一个nil
//            DispatchQueue.main.async {
//                completion(nil)
//            }
//            return
//        }
//    }
//    
//    func getHomeURL() -> String {
//        return "https://zh.video01.ink"
//    }
//    
//    func getNextPageURL(urlStrig: String, nextPage: Int) -> String {
//        if nextPage <= 1 {
//            return urlStrig
//        }
//        if urlStrig.hasPrefix("https://zh.video01.ink/best") {
//            return urlStrig + "/" + String(nextPage-1)
//        } else {
//            return urlStrig + "/new/" + String(nextPage-1)
//        }
//    }
//}
//
//extension StationParserDataCoordinator {
//    private func handleResponse(xpath: String, doc: TFHpple) -> [MovieInfo] {
//        var movieList: [MovieInfo] = []
//        
//        let array = doc.search(withXPathQuery: xpath)
//        if array == nil || array?.count == 0 {
//            return []
//        }
//        if let rootElement = array?[0] as? TFHppleElement {
//            if let childRootElement = rootElement.children[1] as? TFHppleElement {
//                if let childRootArray = childRootElement.children as? NSArray {
//                    for element in childRootArray {
//                        if let element = element as? TFHppleElement {
//                            if !element.isTextNode() {
//                                var _imgSrc = ""
//                                var _href = ""
//                                var _title = ""
//                                
//                                if let xx1 = element.children.first as? TFHppleElement,
//                                    xx1.children.count > 1,
//                                    let xx2 = xx1.children[1] as? TFHppleElement,
//                                   let xx3 = xx2.children.first as? TFHppleElement,
//                                    let xx4 = xx3.children.first as? TFHppleElement,
//                                    let imgSrc = xx4.attributes["data-src"] as? String {
//                                    _imgSrc = imgSrc
//                                }
//                                
//                                if element.children.count > 1 {
//                                    if let xx1 = element.children[1] as? TFHppleElement,
//                                        let xx2 = xx1.children.first as? TFHppleElement,
//                                        let xx3 = xx2.children.first as? TFHppleElement,
//                                        let attributes = xx3.attributes as? NSDictionary {
//                                        if let title = attributes["title"] as? String {
//                                            _title = title
//                                        }
//                                        if let href = attributes["href"] as? String {
//                                            if href.hasPrefix("http") {
//                                                _href = href
//                                            } else {
//                                                _href = "https://zh.video01.ink" + href
//                                            }
//                                        }
//                                        movieList.append(MovieInfo(imgSrc: _imgSrc, title: _title, href: _href))
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        return movieList
//    }
//}
