//
//  FeedInfo.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/07.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

struct UserSettingsFeedData: Codable {
    let group: String
    let url: String
    let title: String?
}

extension UserSettingsFeedData: Mappable {
    static func from(_ map: [String : Any]) -> UserSettingsFeedData? {
        return .init(
            group: map["group"] as! String,
            url: map["url"] as! String,
            title: map["title"] as! String?
        )
    }
    
    func toMap() -> [String : Any] {
        return [
            "group": group,
            "url": url,
            "title": title as Any
        ]
    }
}
