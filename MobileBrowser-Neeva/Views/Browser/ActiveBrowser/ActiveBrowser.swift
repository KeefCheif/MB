//
//  ActiveBrowser.swift
//  MobileBrowser-Neeva
//
//  Created by peter allgeier on 8/20/22.
//

import SwiftUI

struct ActiveBrowser: View {
    
    @ObservedObject var webBrowserState: WebBrowserState
    @Binding var show_active: Bool
    
    var body: some View {
        
        VStack {
            
            if self.webBrowserState.active_webpage.webpage != nil && !self.webBrowserState.active_webpage.show_errorPage {
                
                // Web Browser
                WebBrowser(browserState: self.webBrowserState)
                    .clipped()
                
            } else {
                
                // Error Page
                Spacer()
                
                Text("The website could not be reached.")
                    .fontWeight(.semibold)
                    .font(.title)
                Text("Make sure your search is formatted correctly")
                    .font(.caption)
                
                Spacer()
            }
            
        }
        // Bottom Toolbar
        .safeAreaInset(edge: .bottom) {
            
            VStack(spacing: 0) {
                
                // Search bar
                ActiveBrowserSearchBar(webBrowserState: self.webBrowserState)
                
                // Back, Forward, & Switch Tabs
                ActiveBrowserToolbar(webBrowserState: self.webBrowserState, show_active: self.$show_active)
            }
        }
    }
}
