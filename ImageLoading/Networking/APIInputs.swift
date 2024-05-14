//
//  APIInputs.swift
//  SocialFeed
//
//  Created by V!jay on 13/05/24.
//

import Foundation

enum APIInputs : APIConfiguration {
    case getHomeFeed(limit : String)
    
    var path: String {
        switch self {
        case .getHomeFeed(let limit):
            return Constants.APIPath.homeFeed + "?limit=\(limit)"
        }
    }
    
    var method : String {
        switch self {
        default :
            return "GET"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        default :
            return [:]
        }
    }
}

