//
//  Logger.swift
//  SomariFoundation
//
//  Created by Kazuki Yamamoto on 2019/10/12.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

public enum Logger {
    public enum LogLevel: String {
        case debug = "DEBUG"
        case info = "INFO"
        case warn = "WARN"
        case error = "ERROR"
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"

        return formatter
    }()

    @inlinable
    public static func debug(_ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .debug, message, file: file, function: function, line: line)
    }

    @inlinable
    public static func info(_ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .info, message, file: file, function: function, line: line)
    }

    @inlinable
    public static func warn(_ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .warn, message, file: file, function: function, line: line)
    }

    @inlinable
    public static func error(_ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .error, message, file: file, function: function, line: line)
    }

    @usableFromInline
    static func log(level: LogLevel, _ message: () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let now = Date()
        let fileName = file.split(separator: "/").last ?? ""
        print("[\(level.rawValue)]\(Self.dateFormatter.string(from: now)) \(fileName):\(line) - \(function)\n> \(message())")
        #endif
    }
}

extension Logger {
    @inlinable
    public static func error(_ error: @autoclosure () -> Error, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .error, { error().localizedDescription }, file: file, function: function, line: line)
    }
}
