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
        context.coordinator.hostingController?.rootView = content

        // Use the obfuscated key for updating
        if let inputScaleKey = Obfuscated.inputScaleKey,
           let edrFilter = uiView.layer.filters?.first as? NSObject
        {
            edrFilter.setValue(intensity, forKey: inputScaleKey)
        }

        uiView.setNeedsLayout()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var hostingController: UIHostingController<Content>?
    }
}

