//
//  CustomDateFormatter.swift
//  Somari
//
//  Created by Kazuki Yamamoto on 2019/10/09.
//  Copyright © 2019 Kazuki Yamamoto. All rights reserved.
//

import Foundation

private let minutes: Double = 60
private let hours: Double = minutes * 60
private let days: Double = hours * 24
private let weeks: Double = days * 7

class CustomDateFormatter {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    static func formatDate(from date: Date) -> String {
        let interval = -date.timeIntervalSinceNow
        
        if interval < minutes {
            return "\(Int(interval))s"
        } else if interval < hours {
            return "\(Int(interval / minutes))m"
        } else if interval < days {
            return "\(Int(interval / hours))h"
        } else if interval < weeks {
            return "\(Int(interval / days))d"
        } else {
            return formatter.string(from: date)
        }
    }
}
