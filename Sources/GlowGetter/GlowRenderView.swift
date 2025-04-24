//
//  GlowRenderView.swift
//  GlowGetter
//
//  Created by Aether on 08/03/2025.
//

import SwiftUI

struct GlowRenderView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIGlowView {
        UIGlowView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    class UIGlowView: UIView {
        override class var layerClass: AnyClass { CAMetalLayer.self }
        
        var metalLayer: CAMetalLayer { layer as! CAMetalLayer }
        var renderPass : MTLRenderPassDescriptor?
        var drawable : CAMetalDrawable?
        var commandQueue : MTLCommandQueue?
        var defaultLibrary : MTLLibrary?
        
        init() {
            super.init(frame: .zero)
            setup()
        }
        
        @available(*, unavailable) required init?(coder: NSCoder) { fatalError() }
        
        override func didMoveToWindow() {
            super.didMoveToWindow()
            render()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            // Ensure the Metal layer's frame and drawable size match the view's bounds.
            metalLayer.frame = bounds
            metalLayer.drawableSize = bounds.size
        }
        
        func setup() {
            metalLayer.device = MTLCreateSystemDefaultDevice()
            commandQueue = metalLayer.device!.makeCommandQueue()
            defaultLibrary = metalLayer.device!.makeDefaultLibrary()
            
            // Enable HDR content
            metalLayer.setValue(NSNumber(booleanLiteral: true), forKey: "wantsExtendedDynamicRangeContent")
            
            metalLayer.pixelFormat = .bgr10a2Unorm
            metalLayer.colorspace = CGColorSpace(name: CGColorSpace.displayP3_PQ)
            metalLayer.framebufferOnly = false // Change to false to allow content sampling
            metalLayer.frame = bounds
            metalLayer.backgroundColor = UIColor.clear.cgColor
            metalLayer.isOpaque = false
            metalLayer.drawableSize = frame.size
            
            // Change the blending mode to screen or add to brighten underlying content
            metalLayer.compositingFilter = "multiplyBlendMode"
            
            metalLayer.opacity = 1.0
            
            // Don't render immediately; wait until we have been added to a Window.
        }
        
        @objc public func render() {
            guard let device = metalLayer.device,
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
                drawable = metalLayer.nextDrawable()
            }
            
            return drawable!
        }
    }
}
