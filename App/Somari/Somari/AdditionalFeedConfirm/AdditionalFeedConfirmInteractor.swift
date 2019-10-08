//
//  AdditionalFeedConfirmInteractor.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/09/30.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

protocol AdditionalFeedConfirmInteractable {
    func saveFeedInfo(info: FeedInfo, completion: @escaping (Result<Void, Error>) -> Void)
}

private let feedInfoKey = "feedInfo"

class AdditionalFeedConfirmInteractor: AdditionalFeedConfirmInteractable {
    private let storageService: StorageService

    init(storageService: StorageService) {
        self.storageService = storageService
    }
    
    func saveFeedInfo(info: FeedInfo, completion: @escaping (Result<Void, Error>) -> Void) {
        storageService.add(key: feedInfoKey, info) { (result) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
