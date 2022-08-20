//
//  BrowserManagerView.swift
//  MobileBrowser-Neeva
//
//  Created by peter allgeier on 8/20/22.
//

import SwiftUI

struct BrowserManagerView: View {
    
    @StateObject private var webBrowserState: WebBrowserState = WebBrowserState()
    @State private var show_active: Bool = true
    
    var body: some View {
        
        if self.show_active {
            ActiveBrowser(webBrowserState: self.webBrowserState, show_active: self.$show_active)
        } else {
            TabList(webBrowserState: self.webBrowserState, show_active: self.$show_active)
        }
    }
}
