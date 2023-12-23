//
//  String+Base64.swift
//  StationPlayer
//
//  Created by jack on 2023/10/3.
//

import Foundation

let ZXBA_STRING = "aHR0cDovL3p4YmEuY2M=".fromBase64()

// https://www.videvo.net/stock-video-footage/?type[0]=free#rs=home-explore-all
let VIDVO_STRING = "aHR0cHM6Ly93d3cudmlkZXZvLm5ldC9zdG9jay12aWRlby1mb290YWdlLz90eXBlWzBdPWZyZWUjcnM9aG9tZS1leHBsb3JlLWFsbA==".fromBase64()

// https://www.videvo.net/stock-video-footage/?type[0]=free&page=
let VIDVO_PREFIX = "aHR0cHM6Ly93d3cudmlkZXZvLm5ldC9zdG9jay12aWRlby1mb290YWdlLz90eXBlWzBdPWZyZWUmcGFnZT0=".fromBase64()

// #rs=home-explore-all
let VIDVO_SUFFIX = "I3JzPWhvbWUtZXhwbG9yZS1hbGw=".fromBase64()

// /html/body/main/div[2]/div[3]/div/div[5]/article
let VIDVO_XPATH_PREFIX = "L2h0bWwvYm9keS9tYWluL2RpdlsyXS9kaXZbM10vZGl2L2Rpdls1XS9hcnRpY2xl".fromBase64()


// http://zxba.cc/movie/list
let ZXBA_HOME = "aHR0cDovL3p4YmEuY2MvbW92aWUvbGlzdA==".fromBase64()

// "/html/body/div[6]/div[1]/div[2]/ul"
let ZXBA_XPATH_STEP1 = "L2h0bWwvYm9keS9kaXZbNl0vZGl2WzFdL2RpdlsyXS91bA==".fromBase64()
let ZXBA_XPATH_STEP2 = "L2h0bWwvYm9keS9kaXZbNl0vZGl2L2RpdlsyXS9kaXZbMl0vZGl2L2Rpdi9mb3JtL3VsL2xpWzJdL3NwYW5bMl0vYQ==".fromBase64()
let ZXBA_XPATH_STEP3 = "L2h0bWwvYm9keS9kaXZbNl0vZGl2L2RpdlsyXS9kaXZbMl0vZGl2L2Rpdi9kaXYvZm9ybS91bC9saVsyXS9zcGFuWzJdL2E=".fromBase64()

extension String {
    /// 将String转换为base64
    func toBase64() -> String {
        let data = self.data(using: .utf8)!
        let base64String = data.base64EncodedString()
        return base64String
    }
    
    /// 从base64解码
    func fromBase64() -> String {
        guard let decodedData = NSData(base64Encoded: self, options: []) else {
            return ""
        }
        let decodedString = (String(data: decodedData as Data, encoding: .utf8) ?? "") as String
        return decodedString
    }
}
