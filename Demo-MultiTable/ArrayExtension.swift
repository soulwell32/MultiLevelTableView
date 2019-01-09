//
//  ArrayExtension.swift
//  Demo-MultiTable
//
//  Created by MLin on 2019/1/9.
//  Copyright © 2019 梅霖. All rights reserved.
//

import Foundation

extension Array {
    func filterDuplicates<E: Equatable>(filter: (Element)->E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !self.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}
