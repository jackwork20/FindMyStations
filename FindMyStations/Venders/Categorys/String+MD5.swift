//
//  String+MD5.swift
//  MoviePlayer
//
//  Created by jack on 2023/8/20.
//

import Foundation
import CommonCrypto

// MD5
extension String {
    func ss_md5() -> String? {
        let messageData = self.data(using: String.Encoding.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes { digestBytes in
            messageData.withUnsafeBytes { messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
}
