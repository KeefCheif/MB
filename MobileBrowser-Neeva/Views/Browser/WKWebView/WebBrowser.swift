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
    
    private let BASE_GOOGLE: String = "https://www.google.com/"
    private let SEARCH_GOOGLE: String = "/search?q="
    
    private var google_search: String?
    private var overrideTabHistoryUpdate: Bool = false
    
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
        
        let host: String = webpage.url?.host ?? "unknown host"
        self.active_webpage.tabHistory = TabHistory(point: 0, searches: [BASE_GOOGLE], hosts: [host], urls: [BASE_GOOGLE])
        
        return webpage
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.active_webpage.isLoading = true
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        if webView == self.active_webpage.webpage && !self.overrideTabHistoryUpdate {
            
            let url: String = webView.url?.absoluteString ?? "unknown url"
            let host: String = webView.url?.host ?? "unknown host"
            
            self.handleNewTabHistory()
            
            if let google_search = self.google_search {
                self.active_webpage.tabHistory.searches.append(google_search)
                self.active_webpage.tabHistory.hosts.append(google_search)
            } else {
                self.active_webpage.tabHistory.searches.append(url.count > 50 ? host : url)
                self.active_webpage.tabHistory.hosts.append(host)
            }
            
            self.active_webpage.tabHistory.urls.append(url)
            self.active_webpage.tabHistory.point += 1
            self.active_webpage.search = self.active_webpage.tabHistory.searches[self.active_webpage.tabHistory.point]
            
            self.syncTabChanges()   // might be able to move this to when tabs are switched
        }
        
        self.google_search = nil
        self.overrideTabHistoryUpdate = false
        self.active_webpage.isLoading = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.active_webpage.isLoading = false
    }
    
    func handleNewTabHistory() {
        
        guard self.active_webpage.tabHistory.point < self.active_webpage.tabHistory.searches.count - 1 else { return }
        guard self.active_webpage.tabHistory.searches.count == self.active_webpage.tabHistory.urls.count else { return }
        guard self.active_webpage.tabHistory.searches.count == self.active_webpage.tabHistory.hosts.count else { return }
        guard self.active_webpage.tabHistory.point < self.active_webpage.tabHistory.searches.count else { return }
        guard self.active_webpage.tabHistory.point >= -1 else { return }
        
        let start: Int = self.active_webpage.tabHistory.point + 1
        let end: Int = self.active_webpage.tabHistory.searches.count
        
        self.active_webpage.tabHistory.searches.removeSubrange(start..<end)
        self.active_webpage.tabHistory.hosts.removeSubrange(start..<end)
        self.active_webpage.tabHistory.urls.removeSubrange(start..<end)
    }
    
    func handleBackwardNavigation() {
        guard self.active_webpage.tabHistory.point > 0 else { return }
        self.active_webpage.tabHistory.point -= 1
        self.active_webpage.search = self.active_webpage.tabHistory.searches[self.active_webpage.tabHistory.point]
        self.overrideTabHistoryUpdate = true
    }
    
    func handleForwardNavigation() {
        guard self.active_webpage.tabHistory.point < self.active_webpage.tabHistory.searches.count - 1 else { return }
        self.active_webpage.tabHistory.point += 1
        self.active_webpage.search = self.active_webpage.tabHistory.searches[self.active_webpage.tabHistory.point]
        self.overrideTabHistoryUpdate = true
    }
    
    func refineSearch() {
        
        let search: String = self.active_webpage.search
        
        self.active_webpage.isLoading = true
        var urlSearch: URL?
        
        if URL(string: search) != nil {
            
            if search.contains(".com") {
                
                // User is trying to open a website, so make sure it's correctly formatted
                urlSearch = URL(string: WebBrowserState.prepareWebsiteSearch(search))
                
            } else if UIApplication.shared.canOpenURL(URL(string: search)!) {
                
                // Could be a non .com site, so just try and load that
                urlSearch = URL(string: search)
                
            } else {
                
                // - - - Default to Google Search - - - //
                self.google_search = search
                urlSearch = URL(string: BASE_GOOGLE + SEARCH_GOOGLE + WebBrowserState.prepareGoogleSearch(search))
            }
            
        } else {
            
            // - - - Default to Google Search - - - //
            self.google_search = search
            urlSearch = URL(string: BASE_GOOGLE + SEARCH_GOOGLE + WebBrowserState.prepareGoogleSearch(search))
        }
        
        // - - - Load Request (if url is valid & not nil) - - - //
        if let urlSearch = urlSearch, let _ = self.active_webpage.webpage {
            
            if UIApplication.shared.canOpenURL(urlSearch) {
                self.active_webpage.webpage!.load(URLRequest(url: urlSearch))
            } else {
                self.active_webpage.show_errorPage = true
                self.syncTabChanges()
                self.active_webpage.isLoading = false
            }
            
        } else {
            self.active_webpage.show_errorPage = true
            self.syncTabChanges()
            self.active_webpage.isLoading = false
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
