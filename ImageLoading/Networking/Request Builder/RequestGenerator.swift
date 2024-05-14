//
//  RequestGenerator.swift
//  SocialFeed
//
//  Created by V!jay on 13/05/24.
//

import Foundation

class RequestGenerator : APIManager {
    static var call = RequestGenerator()
    
    func getHomeFeed (limit : String) -> URLRequest {
        let request = try! asURLRequest(.getHomeFeed(limit: limit))
        return request
    }
    
    /// It will generate the baseURL and will be passed for construction of URL
    /// - Parameter apiInput: which type of API input it is
    /// - Returns: it returns the URLRequest
    func asURLRequest(_ apiInput : APIInputs) throws -> URLRequest {
        var baseURLString : String
        
        switch apiInput {
        case .getHomeFeed :
            baseURLString = APIManager.baseImageLoadingURL
        }
        
        return try constructURLRequest(with: baseURLString, apiInput: apiInput)
    }
}
