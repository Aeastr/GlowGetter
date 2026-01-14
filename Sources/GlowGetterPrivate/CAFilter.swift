//
//  CAFilter.swift
//  GlowGetterPrivate
//
//  Created by Aether & Seb Vidal on 24/04/2025.
//

import UIKit
import SwiftUI
import Obfuscate

// MARK: - Obfuscated Strings

internal enum ObfuscatedStrings {
    static let filterClassName = #Obfuscate("CAFilter")
    static let filterWithTypeSelector = #Obfuscate("filterWithType:")
    static let edrFilterType = #Obfuscate("edrGainMultiply")
    static let inputScaleKey = #Obfuscate("inputScale")
    static let enabledKey = #Obfuscate("enabled")
}

// MARK: - CAFilter Creation

/// Creates a `CAFilter` instance using obfuscated private API strings.
internal func CAFilterObfuscated(type: String) -> NSObject? {
    guard let filterClass = NSClassFromString(ObfuscatedStrings.filterClassName) as? NSObject.Type else {
        return nil
    }

    let filterSelector = NSSelectorFromString(ObfuscatedStrings.filterWithTypeSelector)

    guard filterClass.responds(to: filterSelector) else {
        return nil
    }

    guard let filterObject = filterClass.perform(filterSelector, with: type) else {
        return nil
    }

    return filterObject.takeUnretainedValue() as? NSObject
}
