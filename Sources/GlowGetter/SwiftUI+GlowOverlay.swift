//
//  SwiftUI+GlowOverlay.swift
//  GlowGetter
//
//  Created by Aether on 08/03/2025.
//

import SwiftUI

public extension View {
    /// Overlays the view with a glow effect.
    ///
    /// - Parameters:
    ///   - opacity: The opacity of the glow effect (default: `1.0`).
    /// - Returns: A view modified with a glow effect overlay.
    func glow(
        _ intensity: Double = 1.0
    ) -> some View {
        self.overlay {
            GlowRenderView()
                .blendMode(.multiply)
                .opacity(intensity)
        }
    }
}

// You cannot view this in regular previews or sim, you can use 'My Mac | Mac Catalyst', if your mac supports HDR to view it

#Preview {
    VStack(spacing: 40) {
        // Example 1: Text without glow vs. with glow
        VStack(spacing: 10) {
            Text("Normal")
                .font(.title2)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            
            Text("With Glow")
                .font(.title2)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .glow(0.4)
        }
        
        // Example 2: Shape comparison
        HStack(spacing: 40) {
            Circle()
                .fill(Color.green)
                .frame(width: 80, height: 80)
                .overlay(Text("No Glow")
                    .font(.caption)
                    .foregroundColor(.white))
            
            Circle()
                .fill(Color.green)
                .frame(width: 80, height: 80)
                .overlay(Text("Glow")
                    .font(.caption)
                    .foregroundColor(.white))
                .glow(0.5)
                .clipShape(Circle())
        }
    }
    .padding(40)
}

