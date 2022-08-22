//
//  WebBrowser.swift
//  MobileBrowser-Neeva
//
//  Created by peter allgeier on 8/20/22.
//

import SwiftUI
import WebKit

// ~ Note, the WebBrowser is not an actual WKWebView. It simply frames and presents alternating webpages (WKWebViews)
// ~ Alternating becuase the active webpage changes when the user switches tabs
struct WebBrowser: UIViewRepresentable {
    
    @ObservedObject var browserState: WebBrowserState
    
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        guard let webpage = self.browserState.active_webpage.webpage else { return }
        
        // Remove subviews from the WebBrowser then frame and present the active webpage
        uiView.subviews.forEach { $0.removeFromSuperview() }
        webpage.frame = CGRect(origin: .zero, size: UIScreen.main.bounds.size)
        uiView.addSubview(webpage)
    }
}
