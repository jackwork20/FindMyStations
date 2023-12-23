//
//  DemoVideoStationDataCoordinator.swift
//  FindMyStations
//
//  Created by jack on 2023/10/29.
//

import Foundation

class DemoVideoStationDataCoordinator: BaseDataCoordinator {
    let homeURL: String
    
    init(homeURL: String = ZXBA_HOME){
        self.homeURL = homeURL
    }
    
    func getStationURL() -> String {
        return self.homeURL
    }
    
    func getNextPageURL(urlStrig: String, nextPage: Int) -> String {
        if nextPage <= 1 {
            return urlStrig
        }
        
        if urlStrig.hasPrefix(ZXBA_HOME + "/---1-") ||
            urlStrig.hasPrefix(ZXBA_HOME + "/1----") ||
            urlStrig.hasPrefix(ZXBA_HOME + "/3----") ||
            urlStrig.hasPrefix(ZXBA_HOME + "/4----"){
            return urlStrig + "-p" + String(nextPage)
        }
        if urlStrig == ZXBA_HOME {
            return urlStrig + "/-----p" + String(nextPage)
        }
        return urlStrig + String(nextPage)
    }
    
    func loadVideos(pageIndex: Int, completion: @escaping ([MovieInfo]) -> Void) {
        let urlString = self.getNextPageURL(urlStrig: self.getStationURL(), nextPage: pageIndex)
        if let url = URL(string: urlString) {
            fetchHTML(from: url) { htmlString in
                if let htmlString = htmlString {
                    
                    let doc = TFHpple(htmlData: htmlString.data(using: .utf8))
                    let array = doc?.search(withXPathQuery: ZXBA_XPATH_STEP1)
                    
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
                                                                                   _href = "http://zxba.cc" + href
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
    
    func queryDescInfo(descUrl: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: descUrl) else {
            return
        }
        
        fetchHTML(from: url) { htmlString in
            if let htmlString = htmlString {
                let doc: TFHpple = TFHpple(htmlData: htmlString.data(using: .utf8))!
                
                // 有多个的情况下
                let xpath1 = ZXBA_XPATH_STEP2
                
                // 只有一个的情况下
                let xpath2 = ZXBA_XPATH_STEP3
                
                var array = doc.search(withXPathQuery: xpath2)
                if array == nil || array?.count == 0 {
                    array = doc.search(withXPathQuery: xpath1)
                }
                
                var _href: String? = nil
                if let rootElement = array?.first as? TFHppleElement {
                    if let attributes = rootElement.attributes as? NSDictionary {
                        if let href = attributes["href"] as? String {
                            debugPrint("---href: \(href)")
                            _href = href.replacingOccurrences(of: "\\", with: "")
                            _href = href.replacingOccurrences(of: "\'", with: "'")
                            debugPrint("---_href: \(_href)")
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    completion(_href)
                }
            }
        }
    }
}


extension DemoVideoStationDataCoordinator {
    private func handleItem(xpath: String, doc: TFHpple) -> MovieInfo? {
        
        var _imgSrc: String?
        var _href: String?
        var _title: String?
        
        let array = doc.search(withXPathQuery: xpath)
        if array == nil || array?.count == 0 {
            debugPrint("--------------------")
            return nil
        }
        if let rootElement = array?[0] as? TFHppleElement {
            if let childArray = rootElement.children {
                for element in childArray {
                    if let element = element as? TFHppleElement {
                        if !element.isTextNode() {
                            if let xchild = element.children {
                                for element2 in xchild {
                                    if let element2 = element2 as? TFHppleElement {
                                        if !element2.isTextNode() {
                                            if let attribute = element2.attributes as? NSDictionary {
                                                if let src = attribute["src"] as? String {
                                                    if src.hasPrefix("//") {
                                                        _imgSrc = "http:" + src
                                                    } else {
                                                        _imgSrc = src
                                                    }
                                                } else {
                                                    if let child3 = element2.children {
                                                        for element3 in child3 {
                                                            if let element3 = element3 as? TFHppleElement {
                                                                if !element3.isTextNode() {
                                                                    if let attribute = element3.attributes as? NSDictionary {
                                                                        if let href = attribute["href"] as? String {
                                                                            _href = href
                                                                        }
                                                                        
                                                                        // 解析title
                                                                        if let child4 = element3.children {
                                                                            for element4 in child4 {
                                                                                if let element4 = element4 as? TFHppleElement {
                                                                                    if element4.isTextNode() {
                                                                                        if let title = element4.content {
                                                                                            _title = title.trimmingCharacters(in: .whitespacesAndNewlines)
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
                                }
                            }
                        }
                    }
                }
            }
        }
        if let imgSrc = _imgSrc,
           let title = _title,
           let href = _href {
            return MovieInfo(imgSrc: imgSrc, title: title, href: href)
        }
        return nil
    }
}
