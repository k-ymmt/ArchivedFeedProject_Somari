//
//  DummyStorageService.swift
//  FeedsSandbox
//
//  Created by Kazuki Yamamoto on 2019/10/14.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

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

    func add<Value>(key: String, _ value: Value, completion: @escaping (Result<Value, Error>) -> Void) where Value: Encodable {
        storage[key]?.append(value)
        completion(.success(value))
    }

    func get<Value>(key: String, completion: @escaping (Result<[Value], Error>) -> Void) where Value: Decodable {
        guard let values = storage[key] else {
            completion(.failure(StorageError.keyNotFound))
            return
        }

        completion(.success(values.compactMap { $0 as? Value }))
    }
}
