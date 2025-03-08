//
//  GlowOverlayViewController.swift
//  GlowGetter
//
//  Created by Aether on 08/03/2025.
//

import SwiftUI

class GlowOverlayViewController: UIViewController {
    let vividRenderLayer : CAMetalLayer = CAMetalLayer()
    var renderPass : MTLRenderPassDescriptor?
    var drawable : CAMetalDrawable?
    var commandQueue : MTLCommandQueue?
    var defaultLibrary : MTLLibrary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVivid()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Ensure the Metal layer's frame and drawable size match the view's bounds.
        vividRenderLayer.frame = view.bounds
        vividRenderLayer.drawableSize = view.bounds.size
    }
}

extension GlowOverlayViewController {
    
    func setupVivid() {
        vividRenderLayer.device = MTLCreateSystemDefaultDevice()
        commandQueue = vividRenderLayer.device!.makeCommandQueue()
        defaultLibrary = vividRenderLayer.device!.makeDefaultLibrary()
        
        // Enable HDR content
        vividRenderLayer.setValue(NSNumber(booleanLiteral: true), forKey: "wantsExtendedDynamicRangeContent")
        
        vividRenderLayer.pixelFormat = .bgr10a2Unorm
        vividRenderLayer.colorspace = CGColorSpace(name: CGColorSpace.displayP3_PQ)
        vividRenderLayer.framebufferOnly = false // Change to false to allow content sampling
        vividRenderLayer.frame = self.view.bounds
        vividRenderLayer.backgroundColor = UIColor.clear.cgColor
        vividRenderLayer.isOpaque = false
        vividRenderLayer.drawableSize = self.view.frame.size
        
        // Change the blending mode to screen or add to brighten underlying content
        vividRenderLayer.compositingFilter = "multiplyBlendMode"

        vividRenderLayer.opacity = 1.0
        
        self.view.layer.insertSublayer(vividRenderLayer, at: 100)
        
        render()
    }
    
    @objc public func render() {
        guard let device = vividRenderLayer.device,
              let commandQueue = commandQueue else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        commandBuffer?.label = "RenderFrameCommandBuffer"
        
        // Create a texture to sample the underlying content if needed
        // This part would require more complex Metal code to sample the view beneath
        
        let renderPassDescriptor = self.currentFrameBuffer()
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        // Here you would set up a shader that enhances brightness
        // For now, we'll use a simple approach with a brighter clear color
        
        renderEncoder?.endEncoding()
        
        commandBuffer?.present(self.currentDrawable())
        commandBuffer?.commit()
        
        renderPass = nil
        drawable = nil
    }
    
    public func currentFrameBuffer() -> MTLRenderPassDescriptor {
        if (renderPass == nil) {
            let newDrawable = self.currentDrawable()
            
            renderPass = MTLRenderPassDescriptor()
            renderPass?.colorAttachments[0].texture = newDrawable.texture
            renderPass?.colorAttachments[0].loadAction = .clear

            
            // Use a much brighter color for HDR - these values can go beyond 1.0 for HDR
            // Using PQ color space, values like 3.0 or higher will appear very bright on HDR displays
            renderPass?.colorAttachments[0].clearColor = MTLClearColorMake(1.0, 1.0, 1.0, 0.5)
            
            
            renderPass?.colorAttachments[0].storeAction = .store
        }
        
        return renderPass!
    }
    
    public func currentDrawable() -> CAMetalDrawable {
        while (drawable == nil) {
            drawable = vividRenderLayer.nextDrawable()
        }
        
        return drawable!
    }
}
