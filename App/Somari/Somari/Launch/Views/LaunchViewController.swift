//
//  LaunchViewController.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/06.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    
    private let presenter: LaunchPresentable
    
    init(presenter: LaunchPresentable) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.tryLogin()
    }
}
