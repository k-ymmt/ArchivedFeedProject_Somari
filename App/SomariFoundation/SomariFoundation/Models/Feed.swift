//
//  Feed.swift
//  SomariKit
//
//  Created by Kazuki Yamamoto on 2019/10/11.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

public enum Feed {
    case atom(AtomFeed)
    case rss(RSSFeed)
    
    public var title: String? {
        switch self {
        case .atom(let feed):
            return feed.title
        case .rss(let feed):
            return feed.channel?.title
        }
    }
}
