//
//  FeedsViewController.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/28.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import UIKit
import Combine
import SafariServices

protocol FeedsView: class {
}

class FeedsViewController: UIViewController, FeedsView {
    private let presenter: FeedsPresentable
    
    @IBOutlet private weak var feedsTableView: UITableView!
    
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

        feedsTableView.register(cellType: FeedViewCell.self)
        feedsTableView.estimatedRowHeight = 80
        feedsTableView.dataSource = self
        feedsTableView.delegate = self
        
        presenter.feeds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.feedsTableView.reloadData()
        }.store(in: &cancels)
        presenter.getFeeds()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let index = feedsTableView.indexPathForSelectedRow {
            feedsTableView.deselectRow(at: index, animated: true)
        }
    }
}

extension FeedsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feed = presenter.feeds.value[indexPath.row]
        guard let link = feed.link, let url = URL(string: link) else {
            return
        }
        
        let sfvc = SFSafariViewController(url: url)
        present(sfvc, animated: true)
    }
}

extension FeedsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.feeds.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: FeedViewCell.self)
        let feed = presenter.feeds.value[indexPath.row]
        cell.setup(feed: feed)
        
        return cell
    }
}
