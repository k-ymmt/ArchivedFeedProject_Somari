//
//  ViewControllerWrapper.swift
//  SomariSandboxKit
//
//  Created by Kazuki Yamamoto on 2019/10/14.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import SwiftUI

final class ViewControllerWrapper<UIViewControllerType: UIViewController>: UIViewControllerRepresentable {
    private let builder: () -> UIViewControllerType

    init(_ builder: @escaping () -> UIViewControllerType) {
        self.builder = builder
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ViewControllerWrapper<UIViewControllerType>>) -> UIViewControllerType {
        return builder()
    }

    func updateUIViewController(
        _ uiViewController: UIViewControllerType,
        context: UIViewControllerRepresentableContext<ViewControllerWrapper<UIViewControllerType>>
    ) {

    }
}
