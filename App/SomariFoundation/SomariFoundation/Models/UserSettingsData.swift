//
//  UserSettingsData.swift
//  SomariKit
//
//  Created by Kazuki Yamamoto on 2019/10/11.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

public struct UserSettingsFeedData: Codable {
    public let group: String
    public let url: String
    public let title: String?

    public init(group: String, url: String, title: String?) {
        self.group = group
        self.url = url
        self.title = title
    }
}
