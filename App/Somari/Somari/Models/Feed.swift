//
//  Feed.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

enum Feed {
    case atom(AtomFeed)
    case rss(RSSFeed)
}
