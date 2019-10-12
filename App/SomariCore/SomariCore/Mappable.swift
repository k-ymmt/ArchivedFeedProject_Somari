//
//  Arrayable.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/08.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

protocol Mappable: Codable {
    static func from(_ map: [String: Any]) -> Self?
    func toMap() -> [String: Any]
}
