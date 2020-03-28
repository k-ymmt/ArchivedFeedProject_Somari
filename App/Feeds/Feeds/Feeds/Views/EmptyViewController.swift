//
//  EmptyViewController.swift
//  Feeds
//
//  Created by Kazuki Yamamoto on 2020/03/28.
//  Copyright © 2020 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class EmptyViewController: UIViewController {
    enum Output {
        case linkButtonTapped
    }
    
    @IBOutlet private weak var linkButton: UIButton!

    private let outputCallback: (Output) -> Void
    
    private var cancellables: Set<AnyCancellable> = Set()
    

    init(output: @escaping (Output) -> Void) {
        self.outputCallback = output
        
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        linkButton.event(event: .touchUpInside)
            .sink { [weak self] _ in
                self?.outputCallback(.linkButtonTapped)
        }.store(in: &cancellables)
    }
}
