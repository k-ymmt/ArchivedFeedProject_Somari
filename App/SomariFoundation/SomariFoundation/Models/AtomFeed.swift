//
//  AtomFeed.swift
//  SomariKit
//
//  Created by Kazuki Yamamoto on 2019/10/11.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

public struct AtomFeed {
    public struct Author {
        public let name: String?

        public init(name: String?) {
            self.name = name
        }
    }
    public struct Entry {
        public struct Content {
            public enum ContentType {
                case html
            }
            public let type: ContentType?
            public let value: String?

            public init(type: ContentType?, value: String?) {
                self.type = type
                self.value = value
            }
        }
        public struct Link {
            public enum LinkType {
                case html
            }

            public let type: LinkType?
            public let href: String?

            public init(type: LinkType?, href: String?) {
                self.type = type
                self.href = href
            }
        }
        public let id: String?
        public let authors: [Author]?
        public let published: Date?
        public let updated: Date?
        public let links: [Link]?
        public let title: String?
        public let content: Content?

        public init(
            id: String?, authors: [Author]?, published: Date?, updated: Date?,
            links: [Link]?, title: String?, content: Content?
        ) {
            self.id = id
            self.authors = authors
            self.published = published
            self.updated = updated
            self.links = links
            self.title = title
            self.content = content
        }
    }

    public let id: String?
    public let title: String?
    public let description: String?
    public let updated: Date?
    public let authors: [Author]?
    public let entries: [Entry]?

    public init(id: String?, title: String?, description: String?, updated: Date?, authors: [Author]?, entries: [Entry]?) {
        self.id = id
        self.title = title
        self.description = description
        self.updated = updated
        self.authors = authors
        self.entries = entries
    }
}
