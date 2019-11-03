//
//  CoreDataFeedItemCacheServiceTest.swift
//  SomariCoreTests
//
//  Created by Kazuki Yamamoto on 2019/10/21.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import XCTest
import SomariFoundation
@testable import SomariCore

class CoreDataFeedItemCacheServiceTest: XCTestCase {
    
    func testAddItem() throws {
        let service = CoreDataFeedItemCacheService()
        
        try service.addFeedItem(item: makeFeedItem(id: "1"))
        
        var items = try service.getAllFeedItem(limit: 100, offset: 0)
        
        XCTAssertEqual(items?.count, 1)
        XCTAssertEqual(items?.first?.id, "1")
        
        try service.addFeedItems([
            makeFeedItem(title: "Test", id: "2"),
            makeFeedItem(title: "Test", id: "3"),
            makeFeedItem(title: "Test", id: "4"),
            makeFeedItem(title: "Test", id: "5"),
        ])
        
        items = try service.getAllFeedItem(limit: 100, offset: 0)

        XCTAssertEqual(items?.count, 5)
        XCTAssertEqual(items?.map { $0.id }.sorted(by: { $0 < $1 }), ["1", "2", "3", "4", "5"])
        
        try service.removeAll()
    }
    
    func testGetPaging() throws {
        let service = CoreDataFeedItemCacheService()
        
        let items = [Int](0..<500).map {
            makeFeedItem(title: "Test\($0)", id: "\($0)", date: Date(timeIntervalSinceNow: Double.random(in: 0..<5000)))
        }
        try service.addFeedItems(items)
        
        let sorted = items.sorted(by: { $0.date! < $1.date! })
        var feeds = try service.getFeedItem(limit: 30, offset: 0, sortedBy: \.date, ascending: true)

        XCTAssertEqual(feeds?.count, 30)
        XCTAssertEqual(feeds!.map { $0.id }, sorted[0..<30].map {  $0.id })
        
        feeds = try service.getFeedItem(limit: 30, offset: 30, sortedBy: \.date, ascending: true)
        
        XCTAssertEqual(feeds!.map { $0.id }, sorted[30..<60].map { $0.id })
        
        feeds = try service.getFeedItem(limit: 60, offset: 60, sortedBy: \.date, ascending: true)
        
        XCTAssertEqual(feeds!.map { $0.id }, sorted[60..<120].map { $0.id })
        
        try service.removeAll()
    }
    
    func testContains() throws {
        let service = CoreDataFeedItemCacheService()
        
        let items = [Int](0..<10).map {
            makeFeedItem(title: "Title - \($0)", id: "\($0)")
        }
        
        try service.addFeedItems(items)
        
        XCTAssertTrue(try service.contains(key: \.id, value: "5"))
        XCTAssertTrue(try service.contains(key: \.title, value: "Title - 1"))
        XCTAssertFalse(try service.contains(key: \.id, value: "10000"))
        
        try service.removeAll()
    }
    
    private func makeFeedItem(
        title: String? = nil,
        id: String,
        feedID: String? = nil,
        source: String? = nil,
        link: String? = nil,
        date: Date? = nil
    ) -> FeedItem {
        return FeedItem(title: title, id: id, feedID: feedID, source: source, link: link, date: date)
    }
}

