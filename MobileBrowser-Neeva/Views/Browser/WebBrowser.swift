//
//  WebBrowser.swift
//  MobileBrowser-Neeva
//
//  Created by peter allgeier on 8/20/22.
//

import SwiftUI
import WebKit

struct Webpage: Hashable {
    var id: String = UUID().uuidString
    var webpage: WKWebView?
    var url: String = ""
    var host: String = ""
}

// - - - - - - - - - - WebBrowser Coordinator - - - - - - - - - - //

class WebBrowserState: NSObject, WKNavigationDelegate, ObservableObject {
    
    @Published var webpages: [Webpage] = [Webpage]()
    @Published var active_webpage: Webpage = Webpage()
    @Published var tabThumbs: [String: Image] = [String: Image]()
    
    override init() {
        super.init()
        self.createWebpage(withRequest: URLRequest(url: URL(string: "https://www.google.com")!))
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
            
            self.active_webpage.url = url
            self.active_webpage.host = host
            
            for i in 0..<self.webpages.count {
                if self.webpages[i].id == self.active_webpage.id {
                    self.webpages[i].url = url
                    self.webpages[i].host = host
                }
            }
        }
    }
    
    func loadSearch() {
        
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
