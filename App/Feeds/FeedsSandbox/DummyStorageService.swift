//
//  DummyStorageService.swift
//  FeedsSandbox
//
//  Created by Kazuki Yamamoto on 2019/10/14.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

// swiftlint:disable force_cast

import Foundation
import SomariFoundation

enum StorageError: Error {
    case keyNotFound
}

class DummyStorageService: StorageService {
    private var storage: [String: [Any]] = [
        UserSettingsFeedData.key(uid: "1"): [UserSettingsFeedData(
            group: "/",
            url: "https://qiita.com/tags/swift/feed",
            title: "sample"
        )]]

    private var valueChangedSubscriptions: [String: (Result<[Any], Error>) -> Void] = [:]

    func add<Value>(key: String, _ value: Value, completion: @escaping (Result<Value, Error>) -> Void) where Value: Encodable {
        if !storage.keys.contains(key) {
            storage[key] = []
        }
        storage[key]?.append(value)
        if let action = valueChangedSubscriptions[key] {
            action(.success(storage[key]!))
        }
        completion(.success(value))
    }

    func get<Value>(key: String, completion: @escaping (Result<[Value], Error>) -> Void) where Value: Decodable {
        guard let values = storage[key] else {
            completion(.failure(StorageError.keyNotFound))
            return
        }

        completion(.success(values.compactMap { $0 as? Value }))
    }

    func subscribeValues<Value: Decodable>(key: String, subscription: @escaping (Result<[Value], Error>) -> Void) -> Cancellable {
        let action: (Result<[Any], Error>) -> Void = {
            switch $0 {
            case .success(let values):
                let values = values as! [Value]
                subscription(.success(values))
            case .failure(let error):
                subscription(.failure(error))
            }
        }
        valueChangedSubscriptions[key] = action

        return Canceler { [weak self] in
            self?.valueChangedSubscriptions.removeValue(forKey: key)
        }
    }
}

// swiftlint:enable force_cast
