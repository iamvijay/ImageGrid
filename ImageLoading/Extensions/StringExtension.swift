//
//  StringExtension.swift
//  SocialFeed
//
//  Created by V!jay on 13/05/24.
//

import Foundation


extension String {
    /// This it to create image path for storing based on image url, We are removing host url
    /// - Returns: It returns proper path name for file to store image in cache
    func getImagePathForFileURL () -> String {
        let imageURLStr = self
        
        guard let url = URL(string: imageURLStr) else {
            return imageURLStr.components(separatedBy: CharacterSet(charactersIn: ":/")).joined(separator: "_")
        }
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return imageURLStr.components(separatedBy: CharacterSet(charactersIn: ":/")).joined(separator: "_")
        }
        
        // Removing the domain and scheme
        components.scheme = nil
        components.host = nil
        
        // Constructing the new URL
        if let newURL = components.url {
            return newURL.absoluteString.components(separatedBy: CharacterSet(charactersIn: "/")).joined(separator: "_")
        } else {
            return imageURLStr.components(separatedBy: CharacterSet(charactersIn: ":/")).joined(separator: "_")
        }
    }
}

