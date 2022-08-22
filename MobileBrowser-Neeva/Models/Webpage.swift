//
//  Webpage.swift
//  MobileBrowser-Neeva
//
//  Created by peter allgeier on 8/22/22.
//

import WebKit

struct Webpage: Hashable {
    var id: String = UUID().uuidString
    var webpage: WKWebView?
    var host: String = ""
    var search: String = ""
    var urlSearch: Bool = true
    
    var show_errorPage: Bool = false
    
    var isLoading: Bool = false

    var tabHistory: TabHistory = TabHistory()
}

struct TabHistory: Hashable {
    var urls: [String] = [String]()
    var history: [String] = [String]()
}
