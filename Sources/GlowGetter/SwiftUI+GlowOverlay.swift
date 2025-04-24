//
//  SwiftUI+GlowOverlay.swift
//  GlowGetter
//
//  Created by Aether on 08/03/2025.
//

import SwiftUI

public extension View {
    /// Applies an HDR glow effect to the view by increasing its brightness
    /// using a private `CAFilter` accessed via obfuscated strings.
    ///
    /// This modifier wraps the view content in a UIKit view (`FilteredViewRepresentable`)
    /// and applies the `edrGainMultiply` filter to its layer.
    ///
    /// - Warning: This modifier relies on **private Apple APIs** (`CAFilter` and specific
    ///   filter types/keys). Use of private APIs may result in **App Store rejection**.
    ///   This implementation is intended **strictly for experimentation, learning,
    ///   or non-production environments** (but we can't stop you) where App Store rules do not apply.
    ///   The API strings are obfuscated using Base64, but this does not guarantee
    ///   it will evade detection or prevent breakage in future OS updates.
    ///   **Use at your own risk.**
    ///
    /// - Parameter intensity: A multiplier applied to the view's perceived brightness.
    ///   Values greater than `1.0` increase brightness, pushing colors into the
    ///   Extended Dynamic Range (EDR) on compatible displays. Defaults to `1.0` (no change).
    ///   Reasonable EDR values might range from `2.0` to `10.0` or higher, depending
    ///   on the desired effect and display capabilities.
    ///
    /// - Returns: A view modified with the experimental HDR glow effect.
    ///
    /// - Example:
    /// ```swift
    /// Image(systemName: "star.fill")
    ///     .foregroundStyle(.white)
    ///     .glow(intensity: 2.0) // Apply a strong glow
    /// ```
    func glow(_ intensity: Double = 1.0) -> some View {
        FilteredViewRepresentable(content: self, intensity: intensity)
    }
}

// You cannot view this in regular previews or sim, you can use 'My Mac | Mac Catalyst', if your mac supports HDR to view it

#Preview {
    GlowGetterExampleView()
}

public struct GlowGetterExampleView: View {
    @State private var example1GlowIntensity = 0.4
    @State private var example2GlowIntensity = 0.6
    @State private var example3GlowIntensity = 0.8
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                Text(
                    "GlowGetter provides an easy-to-use SwiftUI modifier that overlays a view with a Metal-powered glow effect. With just one simple modifier, you can enhance your views with a subtle or pronounced glow to match your design needs. Under the hood, the package leverages a custom view (named GlowRenderView) that encapsulates Metal's powerful rendering functionalities."
                )
                .font(.caption2)
                .opacity(0.5)
                .padding(.top, 15)
                
                Divider()
                    .opacity(0.8)
                    .padding(.horizontal, 15)
                
                // Example 1: Rounded Rectangles
                VStack(spacing: 12) {
                    Text("Example 1")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.orange)
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.orange)
                            .glow(example1GlowIntensity)
                            .clipShape(.rect(cornerRadius: 15))
                    }
                    .frame(height: 80)
                    
                    Slider(value: $example1GlowIntensity, in: 0...1, step: 0.1)
                        .padding(.horizontal, 15)
                }
                .padding(.vertical, 8)
                
                // Example 2: Circles
                VStack(spacing: 12) {
                    Text("Example 2")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Circle()
                            .fill(Color.red)
                        Circle()
                            .fill(Color.red)
                            .glow(example2GlowIntensity)
                            .clipShape(Circle())
                    }
                    .frame(height: 80)
                    
                    Slider(value: $example2GlowIntensity, in: 0...1, step: 0.1)
                        .padding(.horizontal, 15)
                }
                .padding(.vertical, 8)
                
                // Example 3: Text Blocks
                VStack(spacing: 12) {
                    Text("Example 3")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 10) {
                        Text("Normal Text")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .clipShape(.rect(cornerRadius: 15))
                        
                        Text("Glowing Text")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .glow(example3GlowIntensity)
                    }
                    
                    Slider(value: $example3GlowIntensity, in: 0...1, step: 0.1)
                        .padding(.horizontal, 15)
                }
                .padding(.vertical, 8)
            }
            .padding(.horizontal, 20)
        }
    }
}


struct RoundedGlowContentView: View {
    var body: some View {
        Color.orange
            .clipShape(.rect(cornerRadius: 15))
            .glow(0.8)
    }
}




