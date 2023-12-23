//
//  VidevoDataCoordinator.swift
//  FindMyStations
//
//  Created by jack on 2023/10/29.
//

import Foundation

class VidevoDataCoordinator: BaseDataCoordinator {
    func loadVideos(pageIndex: Int, completion: @escaping ([MovieInfo]) -> Void) {
        let urlString = getNextPageURL(urlStrig: getStationURL(), nextPage: pageIndex)
        guard let url = URL(string: urlString) else {
            return
        }
        
        fetchHTML(from: url) { [weak self] htmlString in
            guard let htmlString = htmlString,
                  let doc = TFHpple(htmlData: htmlString.data(using: .utf8)),
                  let movieList = self?.processMovieInfo(from: doc)
            else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            DispatchQueue.main.async {
                // 采用随机值
                completion(movieList.shuffled())
            }
        }
    }

    private func processMovieInfo(from doc: TFHpple) -> [MovieInfo]? {
        var movieList: [MovieInfo] = []
        
        for i in 1...63 {
            let xpath = VIDVO_XPATH_PREFIX + "[\(i)]"
            if let info = handleResponseItem(xpath: xpath, doc: doc) {
                movieList.append(info)
            }
        }
        
        return movieList.isEmpty ? nil : movieList
    }
    
    func queryDescInfo(descUrl: String, completion: @escaping (String?) -> Void) {
        fatalError("not imepletion")
    }
    
    func getStationURL() -> String {
//        return "https://www.videvo.net/stock-video-footage/?type[0]=free#rs=home-explore-all"
        VIDVO_STRING
    }
    
    func getNextPageURL(urlStrig: String, nextPage: Int) -> String {
        if nextPage <= 1 {
            return urlStrig
        }
        return VIDVO_PREFIX + "\(nextPage)" + VIDVO_SUFFIX
//        return "https://www.videvo.net/stock-video-footage/?type[0]=free&page=\(nextPage)#rs=home-explore-all"
    }
}

extension VidevoDataCoordinator {
    private func handleResponseItem(xpath: String, doc: TFHpple) -> MovieInfo? {
        guard let array = doc.search(withXPathQuery: xpath),
              let rootElement = array.first as? TFHppleElement,
              let childRootElement = rootElement.children[1] as? TFHppleElement,
              let childRootArray = childRootElement.children as? [TFHppleElement]
        else {
            return nil
        }
        
        var movieInfo: MovieInfo?
        var imgSrc = ""
        var title = ""
        var href = ""
//        var description = ""
        
        for element in childRootArray {
            guard !element.isTextNode() else {
                continue
            }
            
            if let itemgroup = element.attributes["itemprop"] as? String {
                switch itemgroup {
                case "contentUrl":
                    href = element.attributes["content"] as? String ?? ""
                case "name":
                    title = element.attributes["content"] as? String ?? ""
//                case "description":
//                    description = element.attributes["content"] as? String ?? ""
                case "thumbnailUrl":
                    imgSrc = element.attributes["content"] as? String ?? ""
                default:
                    break
                }
            }
        }
        
        movieInfo = MovieInfo(imgSrc: imgSrc, title: title, href: href, isDirect: true)
        return movieInfo
    }
}
