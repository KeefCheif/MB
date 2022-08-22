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
    
    @State private var show_history: Bool = false
    @State private var search: String = ""
    
    var body: some View {
        
        if self.show_history {
            
        } else {
            
            VStack {
                
                if self.webBrowserState.active_webpage.webpage != nil && !self.webBrowserState.active_webpage.show_errorPage {
                    WebBrowser(browserState: self.webBrowserState)
                        .clipped()
                } else {
                    Spacer()
                    
                    Text("The website could not be reached.")
                        .fontWeight(.semibold)
                        .font(.title)
                    Text("Make sure '\(self.webBrowserState.active_webpage.tabHistory.searches[self.webBrowserState.active_webpage.tabHistory.point])' is formatted correctly")
                        .font(.caption)
                    
                    Spacer()
                }
                
            }
            .safeAreaInset(edge: .bottom) {
                
                VStack(spacing: 0) {
                    
                    ActiveBrowserSearchBar(webBrowserState: self.webBrowserState)
                    
                    ActiveBrowserToolbar(webBrowserState: self.webBrowserState, show_history: self.$show_history, show_active: self.$show_active)
                }
            }
        }
    }
}
