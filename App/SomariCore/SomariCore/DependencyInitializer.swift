//
//  FirebaseInitializer.swift
//  SomariCore
//
//  Created by Kazuki Yamamoto on 2019/10/13.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import Firebase

public enum DependencyInitializer {
    public static func initialize() {
        FirebaseApp.configure()
    }
}
