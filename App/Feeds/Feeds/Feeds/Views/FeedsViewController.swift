//
//  FeedsViewController.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/28.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import UIKit
import Combine
import SomariFoundation
import SomariKit

class FeedsViewController: UIViewController, ParentViewController {

    private let presenter: FeedsPresentable

    private weak var feedListViewController: FeedListViewController!

    private var cancels: Set<AnyCancellable> = Set()

    init(presenter: FeedsPresentable) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let feedListViewController = FeedListViewController(output: receivedFeedListOutput(value:))
        addViewController(feedListViewController)
        NSLayoutConstraint.activate([
            feedListViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            feedListViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            feedListViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            feedListViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        self.feedListViewController = feedListViewController

        presenter.feeds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.feedListViewController.input(.newFeeds(items))
        }.store(in: &cancels)
    }

    private func receivedFeedListOutput(value: FeedListViewController.Output) {
        switch value {
        case .selectedItem(let item):
            guard let linkString = item.link else {
                return
            }
            presenter.showWebPage(linkString: linkString)
        case .refreshing:
            presenter.getFeedAll()
        }
    }
}
