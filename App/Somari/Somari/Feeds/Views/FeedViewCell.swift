//
//  FeedCell.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/28.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import UIKit

class FeedViewCell: UITableViewCell, NibLoadable {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet private weak var sourceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(feed: FeedItem) {
        titleLabel.text = feed.title
        sourceLabel.text = feed.source
        previewImageView.isHidden = true
    }
}
