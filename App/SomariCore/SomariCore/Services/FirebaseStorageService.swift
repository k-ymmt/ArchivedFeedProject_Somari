//
//  StorageService.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/07.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SomariFoundation

public class FirebaseStorageService: StorageService {
    private let db: Firestore = Firestore.firestore()
    private let encoder = Firestore.Encoder()
    private let decoder = Firestore.Decoder()
    
    public init() {
    }
    
    public func add<Value: Encodable>(key: String, _ value: Value, completion: @escaping (Result<Value, Error>) -> Void) {
        let data: [String: Any]
        do {
            data = try encoder.encode(value)
        } catch {
            completion(.failure(error))
            return
        }
        
        db.collection(key).addDocument(data: data) { error in
            if let error = error {
                completion(.failure(error))
            }
            completion(.success(value))
        }
    }
    
    public func get<Value: Decodable>(key: String, completion: @escaping (Result<[Value], Error>) -> Void) {
        db.collection(key).getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let values = try querySnapshot?.documents.compactMap {
                    try self?.decoder.decode(Value.self, from: $0.data())
                }
                
                completion(.success(values ?? []))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func subscribeValues<Value: Decodable>(key: String, subscription: @escaping (Result<[Value], Error>) -> Void) -> Cancellable {
        let listener = db.collection(key).addSnapshotListener { [weak self] (snapshot, error) in
            guard let self = self else {
                return
            }
            if let error = error {
                subscription(.failure(error))
                return
            }
            guard let documents = snapshot?.documents else {
                Logger.error("snapshot is empty.")
                return
            }
            
            do {
                let values = try documents.compactMap { try self.decoder.decode(Value.self, from: $0.data()) }
                subscription(.success(values))
            } catch {
                Logger.error(error)
                return
            }
        }
        
        return Canceler {
            listener.remove()
        }
    }
}
