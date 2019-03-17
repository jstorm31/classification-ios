//
//  Log.swift
//  Grades
//
//  Created by Jiří Zdvomka on 08/03/2019.
//  Copyright © 2019 jiri.zdovmka. All rights reserved.
//

// swiftlint:disable type_name
class Log {
    static func info(_ message: String) {
        print("ℹ️ \(message)")
    }

    static func debug(_ message: String) {
        print("🐛 \(message)")
    }

    static func error(_ message: String) {
        print("⛔️ \(message)")
    }
}
