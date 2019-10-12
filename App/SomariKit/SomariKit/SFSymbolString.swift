//
//  SFSymbolString.swift
//  SomariKit
//
//  Created by Kazuki Yamamoto on 2019/10/12.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit

public struct SFSymbolName {
    public static let search = SFSymbolName(string: "magnifyingglass.circle")
    public static let list = SFSymbolName(string: "list.dash")
    public static let plusSquare = SFSymbolName(string: "plus.square.on.square")
    
    
    let string: String
    
    private init(string: String) {
        self.string = string
    }
}

extension UIImage {
    public convenience init?(symbol: SFSymbolName, withConfiguration: UIImage.SymbolConfiguration? = nil) {
        self.init(systemName: symbol.string, withConfiguration: withConfiguration)
    }
}
