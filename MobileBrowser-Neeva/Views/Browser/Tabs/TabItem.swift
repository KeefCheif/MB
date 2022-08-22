//
//  TabItem.swift
//  MobileBrowser-Neeva
//
//  Created by peter allgeier on 8/20/22.
//

import SwiftUI

struct TabItem: View {
    
    @ObservedObject var webBrowserState: WebBrowserState
    @Binding var show_active: Bool
    
    let webpage: Webpage
    
    var body: some View {
        
        
        ZStack {
            
            VStack {
                
                // - - - - - Tab Thumbnail - - - - - //
                if let image = self.webBrowserState.tabThumbs[self.webpage.id] {
                    
                    // Thumbnail
                    image
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height/4)
                        .cornerRadius(10)
                } else {
                    
                    // Default image if nil
                    Image("beluga")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height/4, alignment: .center)
                        .cornerRadius(10)
                }
                
                // - - - - - Host Name - - - - - //
                if self.webpage.tabHistory.point >= 0 && self.webpage.tabHistory.point < self.webpage.tabHistory.hosts.count {
                    Text(self.webpage.show_errorPage ? "Invalid Site" : self.webpage.tabHistory.hosts[self.webpage.tabHistory.point])
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }

            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.webBrowserState.active_webpage = self.webpage
                self.show_active = true
            }
            
            // - - - - - Delete Button - - - - - //
            VStack {
                
                HStack {
                    
                    Spacer()
                    
                    Button(action: {
                        self.removeTab()
                    }, label: {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .foregroundStyle(.black, .gray.opacity(0.85))
                    })
                }
                
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height/4)
    }
    
    private func removeTab() {
        self.webBrowserState.webpages.removeAll() { tab in
            return self.webpage.id == tab.id
        }
        
        // Set active page to nil if active page was deleted
        if self.webpage.id == self.webBrowserState.active_webpage.id {
            self.webBrowserState.active_webpage.webpage = nil
        }
    }
}
