//
//  Strings.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit

public struct Strings {
    public struct Views {
        public struct AdditionalFeed {
            public static var title: String { localizedString(name: "views.additional_feed.title") }
            
            private static func localizedString(name: String) -> String {
                NSLocalizedString(name, tableName: "Strings", bundle: Bundle(for: CustomDateFormatter.self), comment: "")
            }
        }
    }
    
    private init() {
    }
}
