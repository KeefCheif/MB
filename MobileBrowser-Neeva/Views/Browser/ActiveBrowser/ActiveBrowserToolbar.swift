//
//  ActiveBrowserToolbar.swift
//  MobileBrowser-Neeva
//
//  Created by peter allgeier on 8/20/22.
//

import SwiftUI
import WebKit

struct ActiveBrowserToolbar: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var webBrowserState: WebBrowserState
    @Binding var show_active: Bool
    
    var body: some View {
        
        HStack(spacing: 40) {
            
            // - - - Back Button - - -//
            Button(action: {
                self.webBrowserState.active_webpage.show_errorPage = false  // Always switch out of error page on navigating action
                self.webBrowserState.handleBackwardNavigation()
                self.webBrowserState.active_webpage.webpage?.goBack()
            }, label: {
                Image(systemName: "arrow.left")
                    .toolbarIcon(nil)
                    .foregroundColor(self.colorScheme == .dark ? .white : .black)
            })
            
            // - - - Forward Button - - - //
            Button(action: {
                self.webBrowserState.active_webpage.show_errorPage = false
                self.webBrowserState.handleForwardNavigation()
                self.webBrowserState.active_webpage.webpage?.goForward()
            }, label: {
                Image(systemName: "arrow.right")
                    .toolbarIcon(nil)
                    .foregroundColor(self.colorScheme == .dark ? .white : .black)
            })
            
            Spacer()
            
            // - - - Switch Tabs Botton - - -//
            Button(action: {
                
                // Capture Screenshot for thumbnail before switching to tab selection list
                Task {
                    do {
                        
                        if self.webBrowserState.active_webpage.show_errorPage {
                            
                            // If error page use default image
                            self.webBrowserState.tabThumbs[self.webBrowserState.active_webpage.id] = nil
                            
                        } else {
                            
                            // Capture and store screenshot
                            let thumbnail = try await self.webBrowserState.active_webpage.webpage?.takeSnapshot(configuration: nil)
                            
                            if let thumbnail = thumbnail {
                                self.webBrowserState.tabThumbs[self.webBrowserState.active_webpage.id] = Image(uiImage: thumbnail)
                            }
                        }
                        
                    } catch {
                        print(error.localizedDescription)
                        // Just log error and display default image on error
                    }
                    
                    self.show_active = false    // Switch to tab list
                }
                
            }, label: {
                Image(systemName: "square.on.square")
                    .toolbarIcon(nil)
                    .foregroundColor(self.colorScheme == .dark ? .white : .black)
            })
        }
        .padding([.horizontal], 20)
        .padding([.vertical], 10)
    }
}
