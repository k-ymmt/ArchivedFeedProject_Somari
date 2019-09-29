//
//  UIColor+Named.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
    struct Color {
        private let name: String
        lazy var uiColor: UIColor = {
            return UIColor(named: name)!
        }()
        
        fileprivate init(from string: String) {
            self.name = string
        }
    }

    static let background = Color(from: "background")
    static let foreground_second = Color(from: "foreground_second")
    static let foreground = Color(from: "foreground")
    static let orange = Color(from: "orange")
    static let red = Color(from: "red")
}
