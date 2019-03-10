//
//  UIColor+.swift
//  Grades
//
//  Created by Jiří Zdvomka on 02/03/2019.
//  Copyright © 2019 jiri.zdovmka. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    struct Theme {
        static let background = UIColor.white
        static let primary = UIColor(hex: 0x9776C1)
        static let secondary = UIColor(hex: 0x6763CE)
        static let text = UIColor(hex: 0x515151)
        static let grayText = UIColor(hex: 0x8B8B8B)

        static let success = UIColor(hex: 0x73C0A2)
        static let danger = UIColor(hex: 0xCB544B)
        static let info = UIColor(hex: 0x7BAFC6)

        static var primaryGradient: CAGradientLayer {
            let gradient: CAGradientLayer = CAGradientLayer()
            let startColor = UIColor(hex: 0x8C72C4).cgColor
            let endColor = UIColor(hex: 0x7468CA).cgColor

            gradient.colors = [startColor, endColor]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.6)
            gradient.endPoint = CGPoint(x: 0.75, y: 0.0)

            return gradient
        }
    }

    /// Create UIColor from RGB
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }

    // Create UIColor from a hex value
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
}
