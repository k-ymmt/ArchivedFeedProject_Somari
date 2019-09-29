//
//  RSSFeed.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

struct RSSFeed {
    struct Channel {
        let title: String?
        let description: String?
        let pubDate: Date?
    }
    struct Item {
        let title: String?
        let link: String?
        let description: String?
        let pubDate: Date?
    }
    
    let channel: Channel?
    let items: [Item]?
}
