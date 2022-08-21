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
            
            
            TextField("website name", text: self.focused ? self.$webBrowserState.active_webpage.url : self.$webBrowserState.active_webpage.host)
                .focused(self.$focused)
            
            Button(action: {
                
                //Need to do some string formatting here
                self.webBrowserState.active_webpage.webpage!.load(URLRequest(url: URL(string: self.webBrowserState.active_webpage.url)!))
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
