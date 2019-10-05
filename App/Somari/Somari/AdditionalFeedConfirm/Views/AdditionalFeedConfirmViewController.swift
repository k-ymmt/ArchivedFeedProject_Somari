//
//  AdditionalFeedConfirmViewController.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import UIKit

class AdditionalFeedConfirmViewController: UIViewController, ParentViewController {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var addButton: UIButton!
    
    private let feedItems: [FeedItem]
    private let presenter: AdditionalFeedConfirmPresentable
    
    
    init(feedItems: [FeedItem], presenter: AdditionalFeedConfirmPresentable) {
        self.feedItems = feedItems
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }

    private func setupFeedListView() {
        let feedListView = FeedListViewController(output: receivedFeedListOutput(output:))
        addViewController(feedListView, to: containerView)
        NSLayoutConstraint.activate([
            feedListView.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            feedListView.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            feedListView.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            feedListView.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
        feedListView.input(.newFeeds(feedItems))
    }

    private func receivedFeedListOutput(output: FeedListViewController.Output) {
        switch output {
        case .selectedItem(let item):
            guard let link = item.link else {
                return
            }
            presenter.showWebPage(linkString: link)
        }
    }

}
