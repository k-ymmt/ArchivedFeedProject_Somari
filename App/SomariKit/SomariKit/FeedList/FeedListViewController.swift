//
//  FeedListViewController.swift
//  SomariKit
//
//  Created by Kazuki Yamamoto on 2019/10/12.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import UIKit
import Combine
import SomariFoundation

public class FeedListViewController: UIViewController {
    public enum Output {
        case selectedItem(FeedItem)
        case refreshing
    }

    public enum Input {
        case updateFeeds([FeedItem])
    }
    
    private enum Section {
        case main
    }

    @IBOutlet private weak var feedListTableView: UITableView!
    
    private var dataSource: UITableViewDiffableDataSource<Section, FeedItem>!

    private let refreshControl: UIRefreshControl = UIRefreshControl()

    private let outputCallback: (Output) -> Void
    private var feeds: [FeedItem] = []
    private var cancellables: Set<AnyCancellable> = Set()

    public init(output: @escaping (Output) -> Void) {
        self.outputCallback = output

        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.feedListTableView.delegate = self
        self.feedListTableView.register(cellType: FeedViewCell.self)

        self.dataSource = UITableViewDiffableDataSource(tableView: feedListTableView) { (tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: FeedViewCell.self)
            cell.setup(feed: item)
            return cell
        }
        
        self.feedListTableView.estimatedRowHeight = 80
        self.feedListTableView.refreshControl = refreshControl
        refreshControl.event(event: .valueChanged)
            .sink { [weak self] (_) in
                self?.outputCallback(.refreshing)
        }.store(in: &cancellables)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let index = feedListTableView.indexPathForSelectedRow {
            feedListTableView.deselectRow(at: index, animated: true)
        }
    }

    public func input(_ value: Input) {
        switch value {
        case .updateFeeds(let feeds):
            var snapshot = NSDiffableDataSourceSnapshot<Section, FeedItem>()
            snapshot.appendSections([.main])
            snapshot.appendItems(feeds)
            dataSource.apply(snapshot)
            
            refreshControl.endRefreshing()
        }
    }
}

extension FeedListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let feed = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        outputCallback(.selectedItem(feed))
    }
}
