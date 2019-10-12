//
//  RSSFeed.swift
//  SomariKit
//
//  Created by Kazuki Yamamoto on 2019/10/11.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

public struct RSSFeed {
    public struct Channel {
        public let title: String?
        public let description: String?
        public let pubDate: Date?
        
        public init(title: String?, description: String?, pubDate: Date?) {
            self.title = title
            self.description = description
            self.pubDate = pubDate
        }
    }
    public struct Item {
        public let title: String?
        public let guid: String?
        public let link: String?
        public let description: String?
        public let pubDate: Date?
        
        public init(title: String?, guid: String?, link: String?, description: String?, pubDate: Date?) {
            self.title = title
            self.guid = guid
            self.link = link
            self.description = description
            self.pubDate = pubDate
        }
    }
    
    public let channel: Channel?
    public let items: [Item]?
    
    public init(channel: Channel?, items: [Item]?) {
        self.channel = channel
        self.items = items
    }
}
