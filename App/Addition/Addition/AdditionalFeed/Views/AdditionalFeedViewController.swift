//
//  AdditionalFeedViewController.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import UIKit
import Combine
import SomariKit

class AdditionalFeedViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var additionalButton: UIButton!
    @IBOutlet weak var bottomButtonConstraint: NSLayoutConstraint!

    private let presenter: AdditionalFeedPresentable
    private var keyboardNotificationCancellable: Set<AnyCancellable> = Set()
    private var cancellables: Set<AnyCancellable> = Set()

    init(presenter: AdditionalFeedPresentable) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Strings.Views.AdditionalFeed.title
        navigationController?.navigationBar.backgroundColor = Colors.background.uiColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        scrollView.keyboardDismissMode = .interactive
        scrollView.gesture(event: .tap, options: .cancelsTouchesInView)
            .sink { [weak self] (_) in
                self?.view.endEditing(true)
        }.store(in: &cancellables)

        additionalButton.event(event: .touchUpInside)
            .sink { [weak self] _ in
                self?.getFeed()
        }.store(in: &cancellables)

        presenter.getFeedSuccess
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.urlTextField.text = ""
        }.store(in: &cancellables)
        presenter.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.showErrorDialog($0) }
            .store(in: &cancellables)

        urlTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = false

        NotificationCenter.default.publisher(for: UIWindow.keyboardDidShowNotification)
            .sink(receiveValue: keyboardDidShow(notification:))
            .store(in: &keyboardNotificationCancellable)

        NotificationCenter.default.publisher(for: UIWindow.keyboardWillHideNotification)
            .sink(receiveValue: keyboardWillHide(notification:))
            .store(in: &keyboardNotificationCancellable)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        keyboardNotificationCancellable.cancel()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func showErrorDialog(_ error: AdditionalFeedError) {
        let message: String
        switch error {
        case .invalidURL:
            message = "URLが正しくありません。"
        case .notFeedURL:
            message = "フィードを取得できませんでした。\nURLが正しいか確認してください。"
        case .getFeedFailed:
            message = "フィードが取得できませんでした。\n時間を置いてお試しください。"
        }
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    private func keyboardDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboard = userInfo[UIWindow.keyboardFrameEndUserInfoKey] as? NSValue,
            let animationDuration = (userInfo[UIWindow.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue else {
            return
        }

        let rect = keyboard.cgRectValue

        UIView.animate(withDuration: animationDuration) {
            self.bottomButtonConstraint.constant = rect.height - self.view.safeAreaInsets.bottom
        }
    }

    private  func keyboardWillHide(notification: Notification) {
        bottomButtonConstraint.constant = 0
    }

    private func getFeed() {
        guard let url = urlTextField.text else {
            return
        }
        presenter.getFeed(urlString: url)
    }
}

extension AdditionalFeedViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.getFeed()
        return true
    }
}
