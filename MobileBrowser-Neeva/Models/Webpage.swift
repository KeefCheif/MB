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
    var search: String = ""
    
    var show_errorPage: Bool = false
    
    var isLoading: Bool = false

    var tabHistory: TabHistory = TabHistory()
}

struct TabHistory: Hashable {
    var point: Int = -1
    var searches: [String] = [String]()
    var hosts: [String] = [String]()
    var urls: [String] = [String]()
}

/*
Scenarios:

    User Makes a valid search:
 
    - Remove all elements in the urls & history arrays past the point value
        
        Case #1: is google search
 
            - Append the google search to the urls & history array
 
        Case #2: is website search
 
            - Append the website host name to the hosts array and url to the urls array
 
    
    User navigates to a new page via the web view:
    
    - Remove all elements in the urls & history arrays past the point value
 
    - Append the website host name to the hosts array and url to the urls array
 
 
    User navigates backwards:
 
    - decrement the point value
 
 
    user navigates forwards:
 
    - increment the point value
 
 
    user reloads:
    
    - Do nothing
*/
