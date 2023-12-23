////
////  PhotoUtils.swift
////  StationPlayer
////
////  Created by jack on 2023/9/28.
////
//
//import Foundation
//import Photos
//
//struct PhotoUtils {
//    static let shared = PhotoUtils()
//    
//    lazy var photosArray : PHFetchResult<PHAsset> = {
//        let allOptions = PHFetchOptions()
//        allOptions.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
//        let allResults = PHAsset.fetchAssets(with: allOptions)
//        return allResults
//    }()
//    
//    func test() {
//        let assetCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
//        assetCollections.enumerateObjects { assetCollection, index, stop in
//            self.handleAssetCollection(assetCollection: assetCollection)
//        }
//    }
//    
//    func handleAssetCollection(assetCollection: PHAssetCollection) {
//        let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
//        assets.enumerateObjects { asset, index, stop in
//            let options = PHVideoRequestOptions()
//            options.version = .current
//            options.deliveryMode = .automatic
//            options.isNetworkAccessAllowed = true
//            PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { item, audioMix, info in
//                if let urlAsset = item as? AVURLAsset {
//                    let url = urlAsset.url
//                    let time: CMTime = urlAsset.duration
//                    let seconds = time.seconds
//                    let str_minute = String(seconds/60)
//                    let str_second = String(Int(seconds) % 60)
//                    let format_time = str_minute + ":" + str_second
//                    print("url: \(url) format_time: \(format_time)")
//                }
//            }
//        }
//    }
//}
//
