//
//  FeedItemCacheService.swift
//  SomariCore
//
//  Created by Kazuki Yamamoto on 2019/10/20.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import SomariFoundation
import CoreData

private extension FeedItemModel {
    convenience init(context: NSManagedObjectContext, feedItem: FeedItem) {
        self.init(context: context)

        self.id = feedItem.id
        self.title = feedItem.title
        self.source = feedItem.source
        self.date = feedItem.date
        self.link = feedItem.link
    }
}

private let containerName: String = "FeedItemModel"

public class CoreDataFeedItemCacheService: FeedItemCacheService {
    private var container: NSPersistentContainer?
    public init() {
        guard let path = Bundle(for: type(of: self)).url(forResource: "FeedItemModel", withExtension: "momd"),
            let managedObjectModel = NSManagedObjectModel(contentsOf: path) else {
                return
        }
        container = NSPersistentContainer(name: containerName, managedObjectModel: managedObjectModel)

        container?.loadPersistentStores { [weak self] (_, error) in
            if let error = error {
                Logger.error(error)
                self?.container = nil
            }
        }
    }

    public func addFeedItem(item: FeedItem) throws {
        try save { context -> Void in
            makeFeedItemModel(context: context, item: item)
        }
    }

    public func addFeedItems(_ items: [FeedItem]) throws {
        try save { context in
            for item in items {
                makeFeedItemModel(context: context, item: item)
            }
        }
    }

    public func getAllFeedItem(limit: Int, offset: Int) throws -> [FeedItem]? {
        return try fetchFeedItem { request in
            request.fetchLimit = limit
            request.fetchOffset = offset
            return request
        }
    }

    public func getFeedItem<T>(
        limit: Int, offset: Int,
        sortedBy item: KeyPath<FeedItem, T>, ascending: Bool
    ) throws -> [FeedItem]? where T: Comparable {
        return try fetchFeedItem { (request) in
            request.fetchLimit = limit
            request.fetchOffset = offset

            let path: AnyKeyPath
            switch item {
            case \FeedItem.id:
                path = \FeedItemModel.id
            case \FeedItem.feedID:
                path = \FeedItemModel.feedId
            case \FeedItem.date:
                path = \FeedItemModel.date
            case \FeedItem.title:
                path = \FeedItemModel.title
            case \FeedItem.link:
                path = \FeedItemModel.link
            case \FeedItem.source:
                path = \FeedItemModel.source
            default:
                Logger.warn("KeyPath not found: \(item)")
                return request
            }

            // swiftlint:disable:next force_cast
            let descriptor = NSSortDescriptor(keyPath: path as! KeyPath<FeedItemModel, T>, ascending: ascending)
            request.sortDescriptors = [descriptor]

            return request
        }
    }

    public func removeAll() throws {
        try save { context in
            let request = FeedItemModel.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            try context.execute(deleteRequest)
        }
    }

    public func contains<T: Comparable, V: CVarArg & Comparable>(key: KeyPath<FeedItem, T>, value: V) throws -> Bool {
        let name: String
        switch key {
        case \FeedItem.id:
            name = "id"
        case \FeedItem.feedID:
            name = "feedId"
        case \FeedItem.link:
            name = "link"
        case \FeedItem.title:
            name = "title"
        case \FeedItem.source:
            name = "source"
        case \FeedItem.date:
            name = "date"
        default:
            Logger.warn("invalid key: \(key)")
            return false
        }

        let result = try fetchFeedItem { request in
            request.predicate = NSPredicate(format: "%K = %@", name, value)
            return request
        }

        guard let items = result else {
            return false
        }

        return !items.isEmpty
    }

    private func fetchFeedItem(builder: (NSFetchRequest<FeedItemModel>) -> NSFetchRequest<FeedItemModel>) throws -> [FeedItem]? {
        let result = try save { context -> [FeedItemModel] in
            let request: NSFetchRequest<FeedItemModel> = FeedItemModel.fetchRequest()

            return try context.fetch(builder(request))
        }

        guard let items = result else {
            return nil
        }
        return items.map { FeedItem(
            title: $0.title,
            id: $0.id ?? "",
            feedID: $0.id,
            source: $0.source,
            link: $0.link,
            date: $0.date
        )}
    }

    @discardableResult
    private func makeFeedItemModel(context: NSManagedObjectContext, item: FeedItem) -> FeedItemModel {
        let model = FeedItemModel(context: context)
        model.id = item.id
        model.title = item.title
        model.source = item.source
        model.date = item.date
        model.link = item.link

        return model
    }

    private func save<T>(_ action: (NSManagedObjectContext) throws -> T) throws -> T? {
        guard let context = container?.viewContext else {
            return nil
        }

        let result = try action(context)

        if context.hasChanges {
            try context.save()
        }

        return result
    }
}
