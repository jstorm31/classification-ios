//
//  Constants.swift
//  Grades
//
//  Created by Jiří Zdvomka on 27/09/2019.
//  Copyright © 2019 jiri.zdovmka. All rights reserved.
//

enum Constants {
    static func gdprCompliantKey(for user: String) -> String {
        return "GdprCompliant.\(user)"
    }
}
