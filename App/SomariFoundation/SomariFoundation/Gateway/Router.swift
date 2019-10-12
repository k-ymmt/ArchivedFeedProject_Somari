//
//  ViewControllerProtocol.swift
//  SomariFoundation
//
//  Created by Kazuki Yamamoto on 2019/10/12.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit

public protocol NavigationAction {
}

public protocol Router {
    associatedtype Dependency
    associatedtype Navigation: NavigationAction
    
    static func assembleModules(dependency: Dependency, action: @escaping (Navigation) -> Void) -> UIViewController
}
