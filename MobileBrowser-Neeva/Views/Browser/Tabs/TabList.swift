//
//  TabList.swift
//  MobileBrowser-Neeva
//
//  Created by peter allgeier on 8/20/22.
//

import SwiftUI

struct TabList: View {
    
    @ObservedObject var webBrowserState: WebBrowserState
    @Binding var show_active: Bool
    @Environment(\.colorScheme) var colorScheme
    
    private let list_columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    
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
                        
                        Button(tab.url?.host ?? "unkown host") {
                            self.webBrowserState.active_webpage = tab
                            withAnimation() {
                                self.show_active = true
                            }
                        }
                    }
                }
                .padding(.top, 30)
                .padding()
            }
            .safeAreaInset(edge: .bottom) {
                
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
    }
}

extension View {
    func getScreenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}
