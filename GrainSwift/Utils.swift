//
//  Utils.swift
//  GrainSwift
//
//  Created by lucas kuzma on 1/6/21.
//

import Foundation

public func clamp<T>(_ value: T, minValue: T, maxValue: T) -> T where T : Comparable {
    return min(max(value, minValue), maxValue)
}
