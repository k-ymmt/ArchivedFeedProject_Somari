//
//  Views.swift
//  SomariKit
//
//  Created by Kazuki Yamamoto on 2020/03/28.
//  Copyright © 2020 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    var constraint: Constraint {
        Constraint(view: self)
    }
}

public struct Constraint {
    fileprivate var view: UIView
    
    fileprivate init(view: UIView) {
        self.view = view
        view.translatesAutoresizingMaskIntoConstraints = false
    }
}

public extension Constraint {
    func full(in view: UIView, top: CGFloat = 0, bottom: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0) {
        NSLayoutConstraint.activate([
            self.view.topAnchor.constraint(equalTo: view.topAnchor, constant: top),
            self.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom),
            self.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading),
            self.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing)
        ])
    }
}
