//
//  UIColor+Named.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit

public struct Colors {
    public struct Color {
        private let name: String
        public let uiColor: UIColor
        
        fileprivate init(from string: String) {
            self.name = string
            self.uiColor = UIColor(named: string, in: Bundle(for: CustomDateFormatter.self), compatibleWith: .current)!
        }
    }

    public static let background = Color(from: "background")
    public static let background_second = Color(from: "background_second")
    public static let foreground = Color(from: "foreground")
    public static let foreground_second = Color(from: "foreground_second")
    public static let orange = Color(from: "orange")
    public static let red = Color(from: "red")
    public static let blue = Color(from: "blue")
    public static let aqua = Color(from: "aqua")
}
