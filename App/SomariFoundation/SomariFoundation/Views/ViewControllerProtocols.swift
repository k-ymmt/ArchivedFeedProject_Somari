//
//  ViewControllerProtocols.swift
//  SomariKit
//
//  Created by Kazuki Yamamoto on 2019/10/11.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit

public protocol ChildViewController: UIViewController {
    associatedtype Input
    associatedtype Output

    init(output: @escaping (Output) -> Void)
    func input(_ value: Input)
}

public protocol ParentViewController: UIViewController {
    func addViewController(_ viewController: UIViewController, to parentView: UIView?)
}

extension ParentViewController {
    public func addViewController(_ viewController: UIViewController, to parentView: UIView? = nil) {
        guard let parentView: UIView = parentView ?? self.view else {
            return
        }
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(viewController)
        parentView.addSubview(viewController.view)
        viewController.didMove(toParent: viewController)
    }
}
