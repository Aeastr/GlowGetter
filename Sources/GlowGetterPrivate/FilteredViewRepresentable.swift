//
//  FilteredViewRepresentable.swift
//  GlowGetterPrivate
//
//  Created by Aether & Seb Vidal on 24/04/2025.
//

import SwiftUI
import UIKit

/// A `UIViewRepresentable` that hosts SwiftUI content and applies a `CAFilter`
/// (specifically the private EDR filter) to its layer.
internal struct FilteredViewRepresentable<Content: View>: UIViewRepresentable {
    let content: Content
    let intensity: Double

    func makeUIView(context: Context) -> UIView {
        let hostingController = UIHostingController(rootView: content)
        let uiView = hostingController.view!
        uiView.backgroundColor = .clear

        if let edrFilter = CAFilterObfuscated(type: ObfuscatedStrings.edrFilterType) {
            edrFilter.setValue(intensity, forKey: ObfuscatedStrings.inputScaleKey)
            edrFilter.setValue(true, forKey: ObfuscatedStrings.enabledKey)
            uiView.layer.filters = [edrFilter]
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

        guard let hostingView = context.coordinator.hostingController?.view else {
            return
        }

        let currentFilterScale = (hostingView.layer.filters?.first as? NSObject)?
            .value(forKey: ObfuscatedStrings.inputScaleKey) as? Double

        if currentFilterScale != intensity {
            hostingView.layer.filters = nil

            if let newFilter = CAFilterObfuscated(type: ObfuscatedStrings.edrFilterType) {
                newFilter.setValue(intensity, forKey: ObfuscatedStrings.inputScaleKey)
                newFilter.setValue(true, forKey: ObfuscatedStrings.enabledKey)
                hostingView.layer.filters = [newFilter]
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var hostingController: UIHostingController<Content>?
    }
}
