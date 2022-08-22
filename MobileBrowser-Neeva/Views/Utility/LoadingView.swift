//
//  LoadingView.swift
//  MobileBrowser-Neeva
//
//  Created by peter allgeier on 8/22/22.
//

import SwiftUI

struct GenericLoadingView: View {
    
    var message: String?
    var size: CGFloat?
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: self.colorScheme == .light ? Color(UIColor.systemGray.withAlphaComponent(0.9)) : Color(UIColor.white.withAlphaComponent(0.9))))
                .scaleEffect(self.size == nil ? 3 : self.size!)
                .padding(2) // Prevents overlapping if the wheel is next to something
            
            if let message = message {
                Text(message)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                    .font(.subheadline)
            }
        }
    }
}
