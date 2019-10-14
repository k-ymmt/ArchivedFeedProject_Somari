//
//  NibLoadable.swift
//  SomariKit
//
//  Created by Kazuki Yamamoto on 2019/10/11.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit

public protocol NibLoadable: class {
}

extension NibLoadable where Self: UIView {
    public static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    public static func loadFromNib() -> Self {
        guard let view = UINib(nibName: String(describing: self), bundle: Bundle(for: self))
            .instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("cannot instantiate \(self)")
        }
        
        return view
    }
}

extension UITableView {
    public func register<Cell: UITableViewCell>(cellType: Cell.Type) where Cell: NibLoadable {
        self.register(cellType.nib, forCellReuseIdentifier: String(describing: cellType))
    }
    
    public func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath, cellType: Cell.Type) -> Cell {
        guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: cellType), for: indexPath) as? Cell else {
            fatalError("failed dequeue cell \(cellType)")
        }
        
        return cell
    }
}
