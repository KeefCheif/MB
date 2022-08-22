//
//  WebBrowserState.swift
//  MobileBrowser-Neeva
//
//  Created by peter allgeier on 8/22/22.
//

import SwiftUI
import WebKit

class WebBrowserState: NSObject, WKNavigationDelegate, ObservableObject {
    
    // - - - Published Variables - - - //
    @Published var webpages: [Webpage] = [Webpage]()                    // tracks all webpages (Tabs)
    @Published var active_webpage: Webpage = Webpage()                  // tracks the active webpage (Tab)
    @Published var tabThumbs: [String: Image] = [String: Image]()       // maps webpages to their tab thumbnail    Key: id  |  Value: thumbnail
    
    // - - - Private Variables - - - //
    private let BASE_GOOGLE: String = "https://www.google.com/"
    private let SEARCH_GOOGLE: String = "/search?q="
    
    private var google_search: String?                                  // Google searches are handled differenlty than url searches
    private var overrideTabHistoryUpdate: Bool = false                  // Skips tabHistory update for the active page
    
    
    override init() {
        super.init()
        // upon launch & re-launch of the app (not re-opening)
        self.createWebpage(withRequest: URLRequest(url: URL(string: BASE_GOOGLE)!))
    }
    
    @discardableResult func createWebpage(withRequest request: URLRequest) -> WKWebView {
        
        let config = WKWebViewConfiguration()
        
        // Set the WKWebView config to mobile so mobile versions of websites are displayed
        // This only works if the websites check the users that visit it
        // Works on Youtube.com (try commenting out this section and accessing youtube via google... as in go to google search for youtube then click on the link from there)
        if #available(iOS 13.0, *) {
            let pref = WKWebpagePreferences.init()
            pref.preferredContentMode = .mobile
            config.defaultWebpagePreferences = pref
        }
        
        // Create WKWebView
        let webpage = WKWebView(frame: CGRect.zero, configuration: config)
        webpage.navigationDelegate = self
        webpage.allowsBackForwardNavigationGestures = true
        webpage.scrollView.isScrollEnabled = true
        webpage.load(request)
        
        // Store WKWebView & initialize crucial values
        var new_webpage = Webpage(webpage: webpage)
        let host: String = webpage.url?.host ?? "unknown host"
        new_webpage.tabHistory = TabHistory(point: 0, searches: [BASE_GOOGLE], hosts: [host], urls: [BASE_GOOGLE])
        
        self.webpages.append(new_webpage)
        self.active_webpage = new_webpage           // New webpages are always made into the active webpage
        
        return webpage
    }
    
    
    // - - - - -  WKWebView Navigation Started - - - - - //
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.active_webpage.isLoading = true
    }
    
    
    // - - - - - WKWebView Navigation First Response - - - - - //
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        // ~ Notice: overrideTabHistoryUpdate
        // Only true when navigating forwards, backwards, and reloading
        if webView == self.active_webpage.webpage && !self.overrideTabHistoryUpdate {
            
            let url: String = webView.url?.absoluteString ?? "unknown url"
            let host: String = webView.url?.host ?? "unknown host"
            
            self.handleNewTabHistory()      // Removes all array values past the point value in the tabHistory
            
            if let google_search = self.google_search {
                
                // Google searches append the actual google search insead of the url because google search urls are very very long
                self.active_webpage.tabHistory.searches.append(google_search)
                self.active_webpage.tabHistory.hosts.append(google_search)
            } else {
                self.active_webpage.tabHistory.searches.append(url.count > 50 ? host : url)     // cut urls for the sake of UI
                self.active_webpage.tabHistory.hosts.append(host)
            }
            
            self.active_webpage.tabHistory.urls.append(url)
            self.active_webpage.tabHistory.point += 1
            
            // Update the bound search value (it is displayed in the UI when the user taps on the search field)
            self.active_webpage.search = self.active_webpage.tabHistory.searches[self.active_webpage.tabHistory.point]
            
            self.syncTabChanges()   // Keep the wepages array synced with the active webpage in case of tab switch
        }
        
        // Reset flags for next navigation action
        self.google_search = nil
        self.overrideTabHistoryUpdate = false
        self.active_webpage.isLoading = false
    }
    
    
    // - - - - - Navigation Finished - - - - - //
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.active_webpage.isLoading = false
    }
    
    
    // - - - - - Pre Navigate Backwards Action - - - - - //
    func handleBackwardNavigation() {
        
        guard self.active_webpage.tabHistory.point > 0 else { return }
        
        // Adjust the tabHistory backwards
        self.active_webpage.tabHistory.point -= 1
        self.active_webpage.search = self.active_webpage.tabHistory.searches[self.active_webpage.tabHistory.point]
        self.overrideTabHistoryUpdate = true
    }
    
    
    // - - - - - Pre Navigate Forwards Action - - - - - //
    func handleForwardNavigation() {
        
        guard self.active_webpage.tabHistory.point < self.active_webpage.tabHistory.searches.count - 1 else { return }
        
        // Adjust tabHisotry forwards
        self.active_webpage.tabHistory.point += 1
        self.active_webpage.search = self.active_webpage.tabHistory.searches[self.active_webpage.tabHistory.point]
        self.overrideTabHistoryUpdate = true
    }
    
    
    // - - - - - Pre Reload - - - - - //
    func handleReload() {
        
        guard self.active_webpage.webpage != nil else { return }
        
        self.active_webpage.webpage!.reload()
        self.overrideTabHistoryUpdate = true
    }
    
    
    // - - - - - Pre WKWebView Load Request - - - - - //
    func refineSearch() {
        
        let search: String = self.active_webpage.search
        
        self.active_webpage.isLoading = true
        var urlSearch: URL?
        
        if URL(string: search) != nil {
            
            // Search is a valid url (does not mean that it is a valid site)
            
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
                
                // Show error page
                self.active_webpage.show_errorPage = true
                self.syncTabChanges()
                self.active_webpage.isLoading = false
            }
            
        } else {
            
            // Show error page
            self.active_webpage.show_errorPage = true
            self.syncTabChanges()
            self.active_webpage.isLoading = false
        }
    }
    
    // - - - - - - - Private Helper Functions - - - - - - - //
    
    private func syncTabChanges() {
        
        // Find the active_page duplicate in the webpages array and update it
        for i in 0..<self.webpages.count {
            if self.webpages[i].id == self.active_webpage.id {
                self.webpages[i] = self.active_webpage
            }
        }
    }
    
    private func handleNewTabHistory() {
        
        // Remove all tabHistory array values (searches, hosts, & urls) past the point value
        guard self.active_webpage.tabHistory.point < self.active_webpage.tabHistory.searches.count - 1 else { return }          // fast exit
        
        // Saftey checks
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
    
    
    private static func prepareWebsiteSearch(_ search: String) -> String {
        
        // Insert https:// & www. if not present
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
        // Replace spaces with +
        return search.replacingOccurrences(of: " ", with: "+")
    }
}
