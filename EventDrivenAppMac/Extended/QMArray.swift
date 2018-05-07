//
//  QMArray.swift
//  TrueBucha
//
//  Created by Kanstantsin Bucha on 1/15/18.
//  Copyright © 2018 Truebucha. All rights reserved.
//

import Foundation

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
