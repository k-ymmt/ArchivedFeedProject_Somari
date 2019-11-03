//
//  AdditionalFeedConfirmViewController.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import UIKit
import Combine
import SomariFoundation
import SomariKit

class AdditionalFeedConfirmViewController: UIViewController, ParentViewController {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var addButton: UIButton!

    private var feedListView: FeedListViewController!

    private let presenter: AdditionalFeedConfirmPresentable

    private var cancellables: Set<AnyCancellable> = Set()

    init(presenter: AdditionalFeedConfirmPresentable) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = Colors.background.uiColor
        setupFeedListView()

        addButton.event(event: .touchUpInside)
            .sink { [weak self] (_) in
                self?.presenter.saveFeedInfo()
        }.store(in: &cancellables)

        presenter.feedItems
            .sink { [weak self] (items) in
                self?.feedListView.input(.updateFeeds(items))
        }.store(in: &cancellables)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = true
    }

    private func setupFeedListView() {
        feedListView = FeedListViewController(output: receivedFeedListOutput(output:))
        addViewController(feedListView, to: containerView)
        NSLayoutConstraint.activate([
            feedListView.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            feedListView.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            feedListView.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            feedListView.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }

    private func receivedFeedListOutput(output: FeedListViewController.Output) {
        switch output {
        case .selectedItem(let item):
            guard let link = item.link else {
                return
            }
            presenter.showWebPage(linkString: link)
        case .refreshing:
            break
        }
    }

}
