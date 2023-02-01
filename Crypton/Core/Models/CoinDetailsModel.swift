//
//  CoinDetailsModel.swift
//  Crypton
//
//  Created by Илья Мишин on 30.01.2023.
//

import Foundation

struct CoinDetailsModel: Codable {
    let id, symbol, name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let categories: [String]?
    let description: Description?
    let links: Links?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
        case categories
        case description, links
    }
    
    var readableDescription: String? {
        return description?.en?.removingHTMLOccurances
    }
}

// MARK: - Description
struct Description: Codable {
    let en: String?
}

// MARK: - Links
struct Links: Codable {
    let homepage: [String]?
    let subredditURL: String?
    
    enum CodingKeys: String, CodingKey {
        case homepage
        case subredditURL = "subreddit_url"
    }
}
