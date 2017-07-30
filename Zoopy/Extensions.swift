//
//  Extensions.swift
//  Zoopy
//
//  Created by Jefferson Bonnaire on 28/07/2017.
//  Copyright © 2017 com.zoopy.app. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func generateRandomPastelColor(withMixedColor mixColor: UIColor?) -> UIColor {
        // Randomly generate number in closure
        let randomColorGenerator = { ()-> CGFloat in
            CGFloat(arc4random() % 256 ) / 256
        }

        var red: CGFloat = randomColorGenerator()
        var green: CGFloat = randomColorGenerator()
        var blue: CGFloat = randomColorGenerator()

        // Mix the color
        if let mixColor = mixColor {
            var mixRed: CGFloat = 0, mixGreen: CGFloat = 0, mixBlue: CGFloat = 0;
            mixColor.getRed(&mixRed, green: &mixGreen, blue: &mixBlue, alpha: nil)

            red = (red + mixRed) / 2;
            green = (green + mixGreen) / 2;
            blue = (blue + mixBlue) / 2;
        }

        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }

        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
