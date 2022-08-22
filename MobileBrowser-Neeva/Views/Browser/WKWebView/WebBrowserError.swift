//
//  WebBrowserError.swift
//  MobileBrowser-Neeva
//
//  Created by peter allgeier on 8/22/22.
//

import Foundation

enum WebBrowserError: Error, LocalizedError {
    
    case websiteNotFound
    
    var errorDescription: String? {
        switch self {
        case .websiteNotFound:
            return NSLocalizedString("The website cannot be found", comment: "")
        }
    }
}
