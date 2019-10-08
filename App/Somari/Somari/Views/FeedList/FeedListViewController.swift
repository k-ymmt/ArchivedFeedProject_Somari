//
//  FeedListViewController.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/29.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import UIKit

class FeedListViewController: UIViewController {
    enum Output {
        case selectedItem(FeedItem)
    }
    
    enum Input {
        case newFeeds([FeedItem])
    }

    @IBOutlet weak var feedListTableView: UITableView!
    
    private let outputCallback: (Output) -> Void
    private var feeds: [FeedItem] = []
    
    init(output: @escaping (Output) -> Void) {
        self.outputCallback = output

        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.feedListTableView.dataSource = self
        self.feedListTableView.delegate = self
        self.feedListTableView.register(cellType: FeedViewCell.self)
        self.feedListTableView.estimatedRowHeight = 80
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let index = feedListTableView.indexPathForSelectedRow {
            feedListTableView.deselectRow(at: index, animated: true)
        }
    }
    
    func input(_ value: Input) {
        switch value {
        case .newFeeds(let feeds):
            self.feeds = feeds.sorted(by: { compareDate($0.date, r: $1.date) })
            feedListTableView.reloadData()
        }
    }
}

private func compareDate(_ l: Date?, r: Date?) -> Bool {
    guard l != r else {
        return true
    }
    guard let l = l else {
        return false
    }
    guard let r = r else {
        return true
    }
    return r < l
}

extension FeedListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feed = feeds[indexPath.row]
        
        outputCallback(.selectedItem(feed))
    }
}

extension FeedListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: FeedViewCell.self)
        let item = feeds[indexPath.row]
        cell.setup(feed: item)
        
        return cell
    }
    
}
