//
//  MockListView.swift
//  SomariSandboxKit
//
//  Created by Kazuki Yamamoto on 2019/10/14.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

public struct ViewControllerListItem: Identifiable {
    public var id: String { title }

    public let title: String
    public let builder: () -> UIViewController

    public init(title: String, builder: @escaping () -> UIViewController) {
        self.title = title
        self.builder = builder
    }
}

public struct MockListView: View {
    private let viewControllerList: [ViewControllerListItem]

    public init(viewControllerList: [ViewControllerListItem]) {
        self.viewControllerList = viewControllerList
    }

    public var body: some View {
        NavigationView {
            List(viewControllerList) { (item) in
                NavigationLink(destination: ViewControllerWrapper(item.builder)) {
                    Text(item.title)
                }
            }
        }
    }
}

struct MockListView_Previews: PreviewProvider {
    static var previews: some View {
        MockListView(viewControllerList: [
            ViewControllerListItem(title: "Sample 1", builder: { UIViewController() })
        ])
    }
}
