//
//  ViewControllerProtocols.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import UIKit

protocol ChildViewController: UIViewController {
    associatedtype Input
    associatedtype Output
    
    init(output: @escaping (Output) -> Void)
    func input(_ value: Input)
}

protocol ParentViewController: UIViewController {
    func addViewController(_ viewController: UIViewController, to parentView: UIView?)
}

extension ParentViewController {
    func addViewController(_ viewController: UIViewController, to parentView: UIView? = nil) {
        guard let parentView: UIView = parentView ?? self.view else {
            return
        }
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(viewController)
        parentView.addSubview(viewController.view)
        viewController.didMove(toParent: viewController)
    }
}
