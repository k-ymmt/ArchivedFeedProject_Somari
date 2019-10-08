//
//  StorageService.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/07.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol StorageService {
    func add<Value: Encodable>(key: String, _ value: Value, completion: @escaping (Result<Value, Error>) -> Void)
    func get<Value: Decodable>(key: String, completion: @escaping (Result<[Value], Error>) -> Void)
}

class FirebaseStorageService: StorageService {
    private let db: Firestore = Firestore.firestore()
    func add<Value: Encodable>(key: String, _ value: Value, completion: @escaping (Result<Value, Error>) -> Void) {
        guard let mappable = value as? Mappable else {
            fatalError("FirebaseStorageService.get required protocol Mappable to value.")
        }
        
        db.collection(key).addDocument(data: mappable.toMap()) { error in
            if let error = error {
                completion(.failure(error))
            }
            completion(.success(value))
        }
    }
    
    func get<Value: Decodable>(key: String, completion: @escaping (Result<[Value], Error>) -> Void) {
        db.collection(key).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            let decoder = FirebaseDocumentDataDecoder()
            let values = querySnapshot?.documents.compactMap { try? decoder.decode(Value.self, from: $0.data()) }
            
            completion(.success(values ?? []))
    }
}

class FirebaseDocumentDataDecoder {
    init() {}

    func decode<T : Decodable>(_ type: T.Type, from data: [String: Any]) throws -> T {
            let decoder = InternalFirebaseDocumentDataDecoder(data: data)
            return try T(from: decoder)
        }
    }
    
    private class InternalFirebaseDocumentDataDecoder: Decoder {
        fileprivate let data: [String: Any]

        var codingPath: [CodingKey] { return [] }

        var userInfo: [CodingUserInfoKey : Any] { return [:] }

        init(data: [String: Any]) {
            self.data = data
        }

        func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
            let container = InternalFirebaseDataDocumentDataKeyedDecodingContainer<Key>(referencing: self)

            return KeyedDecodingContainer(container)
        }

        func unkeyedContainer() throws -> UnkeyedDecodingContainer {

            throw DecodingError.valueNotFound(UnkeyedDecodingContainer.self,
                                              DecodingError.Context(codingPath: self.codingPath,
                                                                    debugDescription: "Cannot get unkeyed decoding container -- found null value instead."))
        }

        func singleValueContainer() throws -> SingleValueDecodingContainer {
            throw DecodingError.typeMismatch(SingleValueDecodingContainer.self,
                                             DecodingError.Context(codingPath: self.codingPath,
                                                                   debugDescription: "Cannot get single value decoding container -- found keyed container instead."))
        }
    }

    private struct InternalFirebaseDataDocumentDataKeyedDecodingContainer<Key : CodingKey> : KeyedDecodingContainerProtocol {
        let decoder: InternalFirebaseDocumentDataDecoder

        var codingPath: [CodingKey]

        init(referencing decoder: InternalFirebaseDocumentDataDecoder) {
            self.decoder = decoder
            self.codingPath = decoder.codingPath
        }

        
        var allKeys: [Key] {
            decoder.data.keys.compactMap { Key(stringValue: $0) }
        }
        
        func contains(_ key: Key) -> Bool {
            decoder.data.keys.contains(key.stringValue)
        }
        
        func decodeNil(forKey key: Key) throws -> Bool {
            decoder.data[key.stringValue] == nil
        }
        
        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
            guard let value = decoder.data[key.stringValue] as? T else {
                throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "type mismatch"))
            }
            
            return value
        }

        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: codingPath,
                                      debugDescription: "not implements")
            )
        }

        func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: codingPath,
                                      debugDescription: "not implements")
            )
        }

        func superDecoder() throws -> Decoder {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: codingPath,
                                      debugDescription: "not implements")
            )
        }

        func superDecoder(forKey key: Key) throws -> Decoder {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: codingPath,
                                      debugDescription: "not implements")
            )
        }
    }
}


