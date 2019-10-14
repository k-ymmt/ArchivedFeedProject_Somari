//
//  ViewControllerProtocol.swift
//  SomariFoundation
//
//  Created by Kazuki Yamamoto on 2019/10/12.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit

public protocol Router {
    associatedtype Dependency
    associatedtype Output
    
    static func assembleModules(dependency: Dependency, action: @escaping (Output) -> Void) -> UIViewController
}

public protocol EmptyOutputRouter {
    associatedtype Dependency
    
    static func assembleModules(dependency: Dependency) -> UIViewController
}
