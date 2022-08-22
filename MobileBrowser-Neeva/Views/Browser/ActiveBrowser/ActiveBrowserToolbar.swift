//
//  ActiveBrowserToolbar.swift
//  MobileBrowser-Neeva
//
//  Created by peter allgeier on 8/20/22.
//

import SwiftUI
import WebKit

struct ActiveBrowserToolbar: View {
    
    @ObservedObject var webBrowserState: WebBrowserState
    @Binding var show_history: Bool
    @Binding var show_active: Bool
    
    var body: some View {
        
        HStack(spacing: 40) {
            
            Button(action: {
                self.webBrowserState.active_webpage.show_errorPage = false
                self.webBrowserState.active_webpage.webpage?.goBack()
            }, label: {
                Image(systemName: "arrow.left")
                    .toolbarIcon(nil)
            })
            
            Button(action: {
                self.webBrowserState.active_webpage.show_errorPage = false
                self.webBrowserState.active_webpage.webpage?.goForward()
            }, label: {
                Image(systemName: "arrow.right")
                    .toolbarIcon(nil)
            })
            
            Spacer()
            
            Button(action: {
                self.webBrowserState.active_webpage.show_errorPage = false
                self.show_history = true
                
            }, label: {
                Image(systemName: "book")
                    .toolbarIcon(nil)
            })
            
            Button(action: {
                
                Task {
                    do {
                        
                        if self.webBrowserState.active_webpage.show_errorPage {
                            
                            self.webBrowserState.tabThumbs[self.webBrowserState.active_webpage.id] = nil
                            
                        } else {
                            
                            let thumbnail = try await self.webBrowserState.active_webpage.webpage?.takeSnapshot(configuration: nil)
                            
                            if let thumbnail = thumbnail {
                                self.webBrowserState.tabThumbs[self.webBrowserState.active_webpage.id] = Image(uiImage: thumbnail)
                            }
                        }
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    self.show_active = false
                }
                
            }, label: {
                Image(systemName: "square.on.square")
                    .toolbarIcon(nil)
            })
        }
        .padding([.horizontal], 20)
        .padding([.vertical], 10)
    }
}

extension Image {
    func toolbarIcon(_ size: CGFloat?) -> some View {
        return self.resizable().scaledToFit().frame(width: size == nil ? 25 : size!).foregroundColor(.white)
    }
}
