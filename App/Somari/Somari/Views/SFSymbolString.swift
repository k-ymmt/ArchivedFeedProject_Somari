//
//  SFSymbolString.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/28.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit

struct SFSymbolName {
    static let search = SFSymbolName(string: "magnifyingglass.circle")
    static let list = SFSymbolName(string: "list.dash")
    static let plusSquare = SFSymbolName(string: "plus.square.on.square")
    
    
    let string: String
    
    private init(string: String) {
        self.string = string
    }
}

extension UIImage {
    convenience init?(symbol: SFSymbolName, withConfiguration: UIImage.SymbolConfiguration? = nil) {
        self.init(systemName: symbol.string, withConfiguration: withConfiguration)
    }
}
