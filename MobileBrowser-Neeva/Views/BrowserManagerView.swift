//
//  BrowserManagerView.swift
//  MobileBrowser-Neeva
//
//  Created by peter allgeier on 8/20/22.
//

import SwiftUI

struct BrowserManagerView: View {
    
    @StateObject private var webBrowserState: WebBrowserState = WebBrowserState()
    @State private var show_active: Bool = false
    
    var body: some View {
        
        if self.show_active {
            
            ActiveBrowser(webBrowserState: self.webBrowserState, show_active: self.$show_active)
                //.frame(width: UIScreen.main.bounds.width)
                .animation(.easeInOut(duration: 0.5), value: self.show_active)
                //.transition(self.show_active ? .backslide : .slide)
            
        } else {
            
            TabList(webBrowserState: self.webBrowserState, show_active: self.$show_active)
                .animation(.easeInOut(duration: 0.5), value: self.show_active)
                //.transition(self.show_active ? .backslide : .slide)
        }
    }
}

extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
    }
}
