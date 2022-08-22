//
//  Webpage.swift
//  MobileBrowser-Neeva
//
//  Created by peter allgeier on 8/22/22.
//

import WebKit

// This is the model structure for the WebBrowserState class
struct Webpage: Hashable {
    
    var id: String = UUID().uuidString
    var isLoading: Bool = false                     // Presents loading icon
    
    var webpage: WKWebView?                         // The actual WKWebView is stored to restore when switching tabs
    
    var search: String = ""                         // Searches are done from here but stored in tabHistory
    var show_errorPage: Bool = false                // Presents invalid page/"site could not be found"
    var tabHistory: TabHistory = TabHistory()
}

// This model is used to track user searches as well as the hosts and urls of sites they navigate to
struct TabHistory: Hashable {
    var point: Int = -1
    var searches: [String] = [String]()
    var hosts: [String] = [String]()
    var urls: [String] = [String]()                 // Currently unused
}
