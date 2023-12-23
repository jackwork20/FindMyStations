//
//  SwiftRadio-Settings.swift
//  Swift Radio
//
//  Created by Matthew Fecher on 7/2/15.
//  Copyright (c) 2015 MatthewFecher.com. All rights reserved.
//

import UIKit

struct Config {
    
    static let debugLog = true

    // If this is set to "true", it will use the JSON file in the app
    // Set it to "false" to use the JSON file at the stationDataURL
    static let useLocalStations = false
//    static let stationsURL = "https://www.bensound.com/royalty-free-music/4"
    static let stationsURL = "https://www.bensound.com/free-music-for-videos"
//https://www.bensound.com/free-music-for-videos/2

    // Set this to "true" to enable the search bar
    static let searchable = false

    // Set this to "false" to show the next/previous player buttons
    static let hideNextPreviousButtons = true
    
    // Contact infos
    static let website = "https://github.com/analogcode/Swift-Radio-Pro"
    static let email = "contact@fethica.com"
    static let emailSubject = "From \(Bundle.main.appName) App"
}

