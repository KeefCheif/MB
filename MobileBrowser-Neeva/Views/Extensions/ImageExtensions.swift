//
//  ImageExtensions.swift
//  MobileBrowser-Neeva
//
//  Created by peter allgeier on 8/22/22.
//

import SwiftUI

extension Image {
    func toolbarIcon(_ size: CGFloat?) -> some View {
        return self.resizable().scaledToFit().frame(width: size == nil ? 25 : size!)
    }
}
