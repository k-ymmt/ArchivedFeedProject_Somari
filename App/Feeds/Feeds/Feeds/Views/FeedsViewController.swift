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

    private weak var feedListViewController: FeedListViewController?
    private weak var emptyViewController: EmptyViewController?

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

        navigationItem.title = "Feeds"
        view.backgroundColor = Colors.background.uiColor
        navigationController?.navigationBar.tintColor = Colors.background.uiColor
        navigationController?.navigationBar.backgroundColor = Colors.background.uiColor

        presenter.feeds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                if items.isEmpty {
                    self?.showEmptyView()
                } else if let feedListViewController = self?.feedListViewController {
                    feedListViewController.input(.updateFeeds(items))
                } else {
                    self?.showFeedList(items: items)
                }
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

    private func showFeedList(items: [FeedItem]) {
        if let emptyViewController = emptyViewController {
            removeViewController(emptyViewController)
            self.emptyViewController = nil
        }
        
        let feedListViewController = FeedListViewController { [weak self]  in self?.receivedFeedListOutput(value: $0) }
        addViewController(feedListViewController)
        self.feedListViewController = feedListViewController
        feedListViewController.view.constraint.full(in: view)
    }
    
    private func showEmptyView() {
        if let feedListViewController = feedListViewController {
            removeViewController(feedListViewController)
            self.feedListViewController = nil
        }
        
        let emptyViewController = EmptyViewController { [weak self] output in
            switch output {
            case .linkButtonTapped:
                self?.presenter.gotoAdditionView()
            }
        }
        
        addViewController(emptyViewController)
        self.emptyViewController = emptyViewController
        emptyViewController.view.constraint.full(in: view)
    }
}
