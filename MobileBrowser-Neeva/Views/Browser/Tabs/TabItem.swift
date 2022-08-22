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
                
                if let image = self.webBrowserState.tabThumbs[self.webpage.id] {
                    image
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height/4)
                        .cornerRadius(10)
                } else {
                    Image("beluga")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height/4, alignment: .center)
                        .cornerRadius(10)
                }
                
                Text(self.webpage.show_errorPage ? "Invalid Site" : self.webpage.host)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.webBrowserState.active_webpage = self.webpage
                self.show_active = true
            }
            
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
        
        if self.webpage.id == self.webBrowserState.active_webpage.id {
            self.webBrowserState.active_webpage.webpage = nil
        }
    }
}
