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
            
            // - - - - - New Tab Button - - - - - //
            Button(action: {
                // Creates new tab & switches the it to the active tab and shows it
                self.webBrowserState.createWebpage(withRequest: URLRequest(url: URL(string: "https://www.google.com")!))
                self.show_active = true
            }, label: {
                Image(systemName: "plus")
                    .toolbarIcon(nil)
                    .foregroundColor(self.colorScheme == .dark ? .white : .black)
            })
            
            Spacer()
            
            // - - - - - Return to active tab Button - - - - - //
            Button(action: {
                
                // If active tab was deleted (is nil) create a new one and make it the active tab
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

