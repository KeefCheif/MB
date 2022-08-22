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
    
    var body: some View {
        
        HStack {
            
            if self.webBrowserState.active_webpage.isLoading {
                GenericLoadingView(size: 1)
            }
            
            TextField("website name", text: self.focused ? self.$webBrowserState.active_webpage.search : self.$webBrowserState.active_webpage.host)
                .focused(self.$focused)
                .textInputAutocapitalization(.never)
            
            Button(action: {
                
                if !self.webBrowserState.active_webpage.search.isEmpty {
                    
                    self.webBrowserState.active_webpage.show_errorPage = false
                    
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
