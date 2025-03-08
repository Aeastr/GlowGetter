//
//  GlowRenderView.swift
//  GlowGetter
//
//  Created by Aether on 08/03/2025.
//

import SwiftUI

struct GlowRenderView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = GlowOverlayViewController
    
    func makeUIViewController(context: Context) -> GlowOverlayViewController {
        let controller = GlowOverlayViewController()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: GlowOverlayViewController, context: Context) {
        
    }
}
