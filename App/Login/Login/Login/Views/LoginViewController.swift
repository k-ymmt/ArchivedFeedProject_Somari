//
//  LoginViewController.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/05.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    @IBOutlet weak var loginAnonymouslyView: UIView!
    private let presenter: LoginPresentable
    
    private var cancellables: Set<AnyCancellable> = Set()
    
    init(presenter: LoginPresentable) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginAnonymouslyView.gesture(event: .tap)
            .sink { [weak self] _ in
                self?.presenter.loginAnonymously()
        }.store(in: &cancellables)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
