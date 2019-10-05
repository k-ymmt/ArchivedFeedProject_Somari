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
        let uiColor: UIColor
        
        fileprivate init(from string: String) {
            self.name = string
            self.uiColor = UIColor(named: string)!
        }
    }

    static let background = Color(from: "background")
    static let background_second = Color(from: "background_second")
    static let foreground = Color(from: "foreground")
    static let foreground_second = Color(from: "foreground_second")
    static let orange = Color(from: "orange")
    static let red = Color(from: "red")
    static let blue = Color(from: "blue")
    static let aqua = Color(from: "aqua")
}
