//
//  ActiveBrowserSearchBar.swift
//  MobileBrowser-Neeva
//
//  Created by peter allgeier on 8/20/22.
//

import SwiftUI

struct ActiveBrowserSearchBar: View {
    
    @ObservedObject var webBrowserState: WebBrowserState
    @FocusState var focused: Bool
    
    private var point: Int {
        return self.webBrowserState.active_webpage.tabHistory.point
    }
    
    var body: some View {
        
        HStack {
            
            // - - - Loading Icon - - - //
            if self.webBrowserState.active_webpage.isLoading {
                GenericLoadingView(size: 1)
            } else {
                
                Button(action: {
                    self.webBrowserState.handleReload()
                }, label: {
                    Image(systemName: "arrow.clockwise")
                        .resizable().scaledToFit().frame(width: 20)
                })
            }
            
            // - - - Search Bar - - - //
            if self.point >= 0 {
                TextField("website name", text: self.focused ? self.$webBrowserState.active_webpage.search : self.$webBrowserState.active_webpage.tabHistory.hosts[self.point])
                    .focused(self.$focused)
                    .textInputAutocapitalization(.never)    // Prevents auto caps on strings like 'https'
            }
            
            // - - - Submit Search Button - - - //
            Button(action: {
                
                if self.point >= 0 && !self.webBrowserState.active_webpage.tabHistory.searches[self.point].isEmpty {
                    
                    self.webBrowserState.active_webpage.show_errorPage = false      // Always remove error page on navigating action
                    
                    // Attempt to load request based on the users search input
                    self.webBrowserState.refineSearch()
                }
    
            }, label: {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
            })
        }
        .padding(10)
        .background(Rectangle().foregroundColor(.gray.opacity(0.5)).cornerRadius(20))
        .padding([.horizontal], 30)
    }
}
