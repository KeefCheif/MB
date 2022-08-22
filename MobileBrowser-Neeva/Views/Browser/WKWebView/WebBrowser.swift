//
//  WebBrowser.swift
//  MobileBrowser-Neeva
//
//  Created by peter allgeier on 8/20/22.
//

import SwiftUI
import WebKit

// - - - - - - - - - - WebBrowser Coordinator - - - - - - - - - - //

class WebBrowserState: NSObject, WKNavigationDelegate, ObservableObject {
    
    @Published var webpages: [Webpage] = [Webpage]()
    @Published var active_webpage: Webpage = Webpage()
    @Published var tabThumbs: [String: Image] = [String: Image]()
    
    private let BASE_GOOGLE: String = "https://www.google.com"
    private let SEARCH_GOOGLE: String = "/search?q="
    
    override init() {
        super.init()
        self.createWebpage(withRequest: URLRequest(url: URL(string: BASE_GOOGLE)!))
    }
    
    @discardableResult func createWebpage(withRequest request: URLRequest) -> WKWebView {
        
        let config = WKWebViewConfiguration()
        
        // Set the WKWebView config to mobile so mobile versions of websites are displayed
        // This only works if the websites check the users
        // Works on Youtube.com (try commenting out this section and accessing youtube via google)
        if #available(iOS 13.0, *) {
            let pref = WKWebpagePreferences.init()
            pref.preferredContentMode = .mobile
            config.defaultWebpagePreferences = pref
        }
        
        let webpage = WKWebView(frame: CGRect.zero, configuration: config)
        webpage.navigationDelegate = self
        webpage.allowsBackForwardNavigationGestures = true
        webpage.scrollView.isScrollEnabled = true
        webpage.load(request)
        
        let new_webpage = Webpage(webpage: webpage)
        self.webpages.append(new_webpage)
        self.active_webpage = new_webpage
        
        return webpage
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if webView == self.active_webpage.webpage {
            
            let url: String = webView.url?.absoluteString ?? "unknown url"
            let host: String = webView.url?.host ?? "unknown host"
            
            if self.active_webpage.urlSearch {
                self.active_webpage.host = host
                self.active_webpage.search = url
            }
            
            // If the user goes back or forward (via the arrows) to a google search, then the search/url will be the entire google search url
            // Just want the actual search for example: www.google.com/search?q=Pokemon&ea=lsjfkljhlkdjfnvkjsdf should just be Pokemon
                // Potential solution... keep track of the searches/urls that have been passed so when we go back we can just move around that array
            
            self.syncTabChanges()
        }
        self.active_webpage.urlSearch = true
    }
    
    func refineSearch() {
        
        var urlSearch: URL?
        
        // Check if the search can be made into a url
        if URL(string: self.active_webpage.search) != nil {
            
            if self.active_webpage.search.contains(".com") {
                
                // User is trying to open a website, so make sure it's correctly formatted
                urlSearch = URL(string: WebBrowserState.prepareWebsiteSearch(self.active_webpage.search))
                self.active_webpage.urlSearch = true
                
            } else if UIApplication.shared.canOpenURL(URL(string: self.active_webpage.search)!) {
                
                // Could be a non .com site
                urlSearch = URL(string: self.active_webpage.search)
                self.active_webpage.host = self.active_webpage.search
                self.active_webpage.urlSearch = true    // Prevents the url shown to the user from being the entire google search url
                
            } else {
                
                // - - - Google Search - - - //
                let googleSearch: String = WebBrowserState.prepareGoogleSearch(self.active_webpage.search)
                urlSearch = URL(string: BASE_GOOGLE + SEARCH_GOOGLE + googleSearch)
                self.active_webpage.urlSearch = false
            }
            
        } else {
            
            // - - - Google Search - - - //
            let googleSearch: String = WebBrowserState.prepareGoogleSearch(self.active_webpage.search)
            urlSearch = URL(string: BASE_GOOGLE + SEARCH_GOOGLE + googleSearch)
            self.active_webpage.host = self.active_webpage.search
            self.active_webpage.urlSearch = false       // Prevents the url shown to the user from being the entire google search url
        }
        
        // - - - Load Request (if url is valid) - - - //
        if let urlSearch = urlSearch, let _ = self.active_webpage.webpage {
            
            if UIApplication.shared.canOpenURL(urlSearch) {
                self.active_webpage.webpage!.load(URLRequest(url: urlSearch))
            } else {
                self.active_webpage.show_errorPage = true
                self.syncTabChanges()
            }
            
        } else {
            self.active_webpage.show_errorPage = true
            self.syncTabChanges()
        }
    }
    
    
    private func syncTabChanges() {
        for i in 0..<self.webpages.count {
            if self.webpages[i].id == self.active_webpage.id {
                self.webpages[i] = self.active_webpage
            }
        }
    }
    
    
    private static func prepareWebsiteSearch(_ search: String) -> String {
        
        var urlString: String = search
        
        if !urlString.contains("https://") {
            urlString = "https://" + urlString
        }
        
        if !urlString.contains("www.") {
            urlString.insert(contentsOf: "www.", at: urlString.index(urlString.startIndex, offsetBy: 8))
        }
        
        return urlString
    }
    
    private static func prepareGoogleSearch(_ search: String) -> String {
        
        //var googleSearch_c: [Character] = Array(search)
        //var crawler: Int = 0
        
        // Remove all non letter and space characters from the search
        // To Do: Allow for non letter characters in google searches
        /*
        while crawler < googleSearch_c.count {
            
            let char: Character = googleSearch_c[crawler]
            
            if ((char < "a" && char > "z") && (char < "A" && char > "Z") && (char != " ")) {
                googleSearch_c.remove(at: crawler)
            } else {
                crawler += 1
            }
        }
        */
        // Convert spaces to + and return the result
        return search.replacingOccurrences(of: " ", with: "+")
    }
}


// - - - - - - - - - - WebBrowser - - - - - - - - - - //

struct WebBrowser: UIViewRepresentable {
    
    @ObservedObject var browserState: WebBrowserState
    
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        guard let webpage = self.browserState.active_webpage.webpage else { return }
        
        
        uiView.subviews.forEach { $0.removeFromSuperview() }
        
        webpage.frame = CGRect(origin: .zero, size: UIScreen.main.bounds.size)
        uiView.addSubview(webpage)
    }
}
