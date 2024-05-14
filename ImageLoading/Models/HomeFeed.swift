//
//  HomeFeed.swift
//  ImageLoading
//
//  Created by V!jay on 13/05/24.
//

import Foundation


import Foundation

protocol Response : Decodable { }

struct HomeFeedPosts: Response, Hashable {
    var id: String
    var title: String
    var language: String
    var thumbnail: Thumbnail?
    var mediaType: Int
    var coverageURL: String
    var publishedAt: String
    var publishedBy: String
    var backupDetails: BackupDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case language
        case thumbnail
        case mediaType
        case coverageURL
        case publishedAt
        case publishedBy
        case backupDetails
    }

    static func == (lhs: HomeFeedPosts, rhs: HomeFeedPosts) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    struct Thumbnail: Codable, Hashable {
        var id: String
        var version: Int
        var domain: String
        var basePath: String
        var key: String
        var qualities: [Int]
        var aspectRatio: Double

        enum CodingKeys: String, CodingKey {
            case id
            case version
            case domain
            case basePath
            case key
            case qualities
            case aspectRatio
        }
    }

    struct BackupDetails: Codable, Hashable {
        var pdfLink: String
        var screenshotURL: String

        enum CodingKeys: String, CodingKey {
            case pdfLink
            case screenshotURL
        }
    }
    
    var thumbnailImageURL : String {
        let domain = thumbnail?.domain ?? " "
        let basePath = thumbnail?.basePath ?? " "
        let key = thumbnail?.key ?? ""
        
        return "\(domain)/\(basePath)/0/\(key)"
    }
}
