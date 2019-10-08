//
//  FeedInfo.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/07.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

struct FeedInfo: Codable {
    let url: String
    let title: String
}

extension FeedInfo: Mappable {
    static func from(_ map: [String : Any]) -> FeedInfo {
        return FeedInfo(
            url: map["url"] as! String,
            title: map["title"] as! String
        )
    }
    
    func toMap() -> [String: Any] {
        return [
            "url": url,
            "title": title
        ]
    }
}
