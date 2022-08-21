//
//  TabList.swift
//  MobileBrowser-Neeva
//
//  Created by peter allgeier on 8/20/22.
//

import SwiftUI

struct TabList: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var webBrowserState: WebBrowserState
    @Binding var show_active: Bool
    
    private let list_columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0), count: 2)
    
    var body: some View {

        ZStack {
            
        // - - - - - Background - - - - - //
            Color(uiColor: .systemPink)
                .ignoresSafeArea()
                .overlay(self.colorScheme == .dark ? .black.opacity(0.35) : .white.opacity(0.35))
                .overlay(.ultraThinMaterial)
                .frame(width: getScreenBounds().width, height: getScreenBounds().height)
        
        // - - - - - List Tabs - - - - - //
            ScrollView(.vertical, showsIndicators: false) {
                
                LazyVGrid(columns: self.list_columns) {
                    
                    ForEach(self.webBrowserState.webpages, id: \.self) { tab in
                        
                        TabItem(webBrowserState: self.webBrowserState, show_active: self.$show_active, webpage: tab)
                            .padding([.vertical], 20)
                    }
                }
                .padding(.top, 20)
                .padding()
            }
            .safeAreaInset(edge: .bottom) {
                
                TabListToolbar(webBrowserState: self.webBrowserState, show_active: self.$show_active)
            }
        }
    }
}

extension View {
    func getScreenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}
