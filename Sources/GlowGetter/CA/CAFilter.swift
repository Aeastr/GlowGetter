//
//  CAFilter.swift
//  GlowGetter
//
//  Created by Aether & Seb Vidal on 24/04/2025.
//

import UIKit
import SwiftUI

// MARK: - Obfuscation Helpers (Internal)

/// Decodes a Base64 encoded string.
/// - Parameter encodedString: The Base64 string to decode.
/// - Returns: The decoded UTF-8 string, or `nil` if decoding fails.
/// - Note: Internal helper for obfuscation.
internal func decodeBase64(_ encodedString: String) -> String? {
    guard let data = Data(base64Encoded: encodedString) else {
        // Keep internal logging minimal, or use a proper logging framework
        // print("Error: Failed to decode Base64 string: \(encodedString)")
        return nil
    }
    return String(data: data, encoding: .utf8)
}

/// Stores obfuscated strings for private API access.
/// - Note: Internal helper to avoid direct string literals for private APIs.
internal enum Obfuscated {
    // "CAFilter"
    static let filterClassName = decodeBase64("Q0FGaWx0ZXI=")
    // "filterWithType:"
    static let filterWithTypeSelectorName = decodeBase64("ZmlsdGVyV2l0aFR5cGU6")
    // "edrGainMultiply"
    static let edrFilterTypeName = decodeBase64("ZWRyR2Fpbk11bHRpcGx5")
    // "inputScale"
    static let inputScaleKey = decodeBase64("aW5wdXRTY2FsZQ==")
    // "enabled"
    static let enabledKey = decodeBase64("ZW5hYmxlZA==")

    // Helper to check if all strings decoded successfully
    static func areValid() -> Bool {
        filterClassName != nil &&
        filterWithTypeSelectorName != nil &&
        edrFilterTypeName != nil &&
        inputScaleKey != nil &&
        enabledKey != nil
    }
}

/// Creates a `CAFilter` instance using obfuscated private API strings.
/// - Parameter type: The string representing the filter type (e.g., "edrGainMultiply" obtained via obfuscation).
/// - Returns: An `NSObject` instance representing the `CAFilter`, or `nil` on failure.
/// - Warning: Relies on private Core Animation APIs. Use only for experimentation.
/// - Note: Internal helper function.
// Helper to create CAFilter using obfuscated private API strings
// WARNING: Using private APIs like CAFilter is not allowed for App Store submission, use at your own risk
internal func CAFilterObfuscated(type: String) -> NSObject? {
    // Ensure all necessary strings were decoded successfully
    guard Obfuscated.areValid(),
          let filterClassName = Obfuscated.filterClassName,
          let filterSelectorName = Obfuscated.filterWithTypeSelectorName
    else {
        print("Error: Could not decode required obfuscated strings.")
        return nil
    }

    guard let filterClass = NSClassFromString(filterClassName) as? NSObject.Type else {
        print("Error: \(filterClassName) class not found.")
        return nil
    }

    let filterSelector = NSSelectorFromString(filterSelectorName)

    guard filterClass.responds(to: filterSelector) else {
        print("Error: \(filterClassName) does not respond to \(filterSelectorName)")
        return nil
    }

    guard let filterObject = filterClass.perform(filterSelector, with: type) else {
        print("Error: Failed to create filter of type: \(type)")
        return nil
    }

    return filterObject.takeUnretainedValue() as? NSObject
}
