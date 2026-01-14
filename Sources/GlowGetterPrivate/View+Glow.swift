//
//  View+Glow.swift
//  GlowGetterPrivate
//
//  Created by Aether & Seb Vidal on 24/04/2025.
//

import SwiftUI

public extension View {
    /// Applies an HDR glow effect using private `CAFilter` APIs.
    ///
    /// This modifier wraps the view in a UIKit view and applies the
    /// `edrGainMultiply` filter to its layer for true HDR brightness.
    ///
    /// - Warning: Uses **private Apple APIs**. May result in App Store rejection.
    ///   Intended for experimentation only. Use at your own risk.
    ///
    /// - Parameter intensity: Brightness multiplier. Values > 1.0 push into EDR range.
    ///   Typical values range from 2.0 to 10.0 depending on desired effect.
    ///
    /// - Returns: A view with the HDR glow effect applied.
    func glowEDR(_ intensity: Double = 2.0) -> some View {
        FilteredViewRepresentable(content: self, intensity: intensity)
    }
}
