//
//  FilteredViewRepresentable.swift
//  GlowGetter
//
//  Created by Aether & Seb Vidal on 24/04/2025.
//

import SwiftUI
import UIKit

// MARK: - Filtered View Representable (Internal Implementation Detail)

/// A `UIViewRepresentable` that hosts SwiftUI content and applies a `CAFilter`
/// (specifically the private EDR filter accessed via obfuscated strings)
/// to its layer.
///
/// - Note: This is an internal implementation detail for the `.glow` modifier.
internal struct FilteredViewRepresentable<Content: View>: UIViewRepresentable {
    let content: Content
    let intensity: Double
    
    func makeUIView(context: Context) -> UIView {
        let hostingController = UIHostingController(rootView: content)
        let uiView = hostingController.view!
        uiView.backgroundColor = .clear
        
        // Use the obfuscated strings for filter type and keys
        if let edrFilterTypeName = Obfuscated.edrFilterTypeName,
           let inputScaleKey = Obfuscated.inputScaleKey,
           let enabledKey = Obfuscated.enabledKey,
           let edrFilter = CAFilterObfuscated(type: edrFilterTypeName) // Use obfuscated creator
        {
            edrFilter.setValue(intensity, forKey: inputScaleKey) // Use obfuscated key
            edrFilter.setValue(true, forKey: enabledKey) // Use obfuscated key
            uiView.layer.filters = [edrFilter]
        } else {
            print("Warning: Could not create or configure EDR filter using obfuscated strings.")
        }
        
        uiView.translatesAutoresizingMaskIntoConstraints = false
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.addSubview(uiView)
        
        NSLayoutConstraint.activate([
            uiView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            uiView.topAnchor.constraint(equalTo: containerView.topAnchor),
            uiView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        
        context.coordinator.hostingController = hostingController
        return containerView
    }
    

    func updateUIView(_ uiView: UIView, context: Context) {

        // Update the SwiftUI content first
        context.coordinator.hostingController?.rootView = content

        // Get the hosting view
        guard let hostingView = context.coordinator.hostingController?.view else {
            // print("Error: hostingView is nil")
            return
        }

        // remove existing filter(s) first, check if the current scale is actually different before doing work
        let currentFilterScale = (hostingView.layer.filters?.first as? NSObject)?
            .value(forKey: Obfuscated.inputScaleKey ?? "") as? Double

        if currentFilterScale != intensity {
            // print("Intensity changed (\(currentFilterScale ?? -1) -> \(intensity)). Re-creating filter.")
            hostingView.layer.filters = nil // Remove existing

            // re-create and add the filter with the current intensity
            if let edrFilterTypeName = Obfuscated.edrFilterTypeName,
               let inputScaleKey = Obfuscated.inputScaleKey,
               let enabledKey = Obfuscated.enabledKey,
               let newFilter = CAFilterObfuscated(type: edrFilterTypeName)
            {
                // print("Creating new filter with intensity: \(intensity)")
                newFilter.setValue(intensity, forKey: inputScaleKey)
                newFilter.setValue(true, forKey: enabledKey)
                hostingView.layer.filters = [newFilter] // Assign the new filter array
                // print("New filter assigned: \(hostingView.layer.filters ?? [])")
            } else {
                // print("Error: Could not create new filter instance or keys missing.")
            }
        } else {
            // print("Intensity hasn't changed (\(intensity)), skipping filter re-creation.")
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var hostingController: UIHostingController<Content>?
    }
}

