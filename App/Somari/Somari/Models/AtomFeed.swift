//
//  AtomFeed.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

struct AtomFeed {
    struct Author {
        let name: String?
    }
    struct Entry {
        struct Content {
            enum ContentType {
                case html
            }
            let type: ContentType?
            let value: String?
        }
        struct Link {
            enum LinkType {
                case html
            }
            
            let type: LinkType?
            let href: String?
        }
        let id: String?
        let authors: [Author]?
        let published: Date?
        let updated: Date?
        let links: [Link]?
        let title: String?
        let content: Content?
    }
    
    let id: String?
    let title: String?
    let description: String?
    let updated: Date?
    let authors: [Author]?
    let entries: [Entry]?
}
