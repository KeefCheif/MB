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
    
    
    @Published var host: String = ""
    @Published var webpages: [WKWebView] = [WKWebView]()
    @Published var active_webpage: WKWebView?
    
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
        
        self.webpages.append(webpage)
        webpage.load(request)
        
        return webpage
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if webView == self.active_webpage {
            self.host = webView.url?.host ?? ""
        }
    }
}


// - - - - - - - - - - WebBrowser - - - - - - - - - - //

struct WebBrowser: UIViewRepresentable {
    
    @ObservedObject var browserState: WebBrowserState
    
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        guard let webpage = self.browserState.active_webpage else { return }
        
        
        uiView.subviews.forEach { $0.removeFromSuperview() }
        
        webpage.frame = CGRect(origin: .zero, size: UIScreen.main.bounds.size)
        uiView.addSubview(webpage)
    }
}

struct WebBrowserTabCard: UIViewRepresentable {
    
    //@ObservedObject var browserState: WebBrowserState
    let webpage: WKWebView
    
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        uiView.subviews.forEach { $0.removeFromSuperview() }
        
        //self.webpage.frame = CGRect(origin: .zero, size: UIScreen.main.bounds.size)
        self.webpage.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 100)
        uiView.addSubview(self.webpage)
    }
}



/*
struct WebBrowser: UIViewRepresentable, Identifiable {
    
    var id: UUID = UUID()
    var tab: Tab
    
    //var onComplete: (String) -> ()
    
    func makeUIView(context: Context) -> some WKWebView  {
        
        let config = WKWebViewConfiguration()
        
        // Set the WKWebView config to mobile so mobile versions of websites are displayed
        // This only works if the websites check the users
        // Works on Youtube.com (try commenting out this section and accessing youtube via google)
        if #available(iOS 13.0, *) {
            let pref = WKWebpagePreferences.init()
            pref.preferredContentMode = .mobile
            config.defaultWebpagePreferences = pref
        }
        
        let webBrowser = WKWebView(frame: CGRect.zero, configuration: config)
        webBrowser.navigationDelegate = context.coordinator
        webBrowser.allowsBackForwardNavigationGestures = true
        webBrowser.scrollView.isScrollEnabled = true
        
        let url = URL(string: tab.url)!
        webBrowser.load(URLRequest(url: url))
        
        return webBrowser
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        let actual_width = (getScreenBounds().width - 60)   // - 60 for the padding
        let card_width = actual_width/4.5                   // 4.5 is just a value that I liked
        
        let scale = card_width/actual_width
        
        //uiView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    class Coordinator: NSObject, WKNavigationDelegate {
        
        let parent: WebBrowser
        
        init(_ parent: WebBrowser) {
            self.parent =  parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            //parent.onComplete(webView.title ?? "unknown host")
        }
    }
}
*/
