//
//  TabListBottomNav.swift
//  MobileBrowser-Neeva
//
//  Created by peter allgeier on 8/20/22.
//

import SwiftUI

struct TabListToolbar: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var webBrowserState: WebBrowserState
    @Binding var show_active: Bool
    
    
    var body: some View {
        
        HStack {
            
            Button(action: {
                self.webBrowserState.createWebpage(withRequest: URLRequest(url: URL(string: "https://www.google.com")!))
                self.show_active = true
            }, label: {
                Image(systemName: "plus")
                    .toolbarIcon(nil)
            })
            
            Spacer()
            
            Button(action: {
                
                if self.webBrowserState.active_webpage.webpage == nil {
                    if self.webBrowserState.webpages.isEmpty {
                        self.webBrowserState.createWebpage(withRequest: URLRequest(url: URL(string: "https://www.google.com")!))
                    } else {
                        self.webBrowserState.active_webpage = self.webBrowserState.webpages.first!
                    }
                }
                
                withAnimation() {
                    self.show_active = true
                }
                
            }, label: {
                Text("Done")
                    .fontWeight(.semibold)
            })
        }
        .padding(20)
        .padding(.bottom, 20)
        .background(self.colorScheme == .dark ? .black : .white)
    }
}

