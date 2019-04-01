//
//  GLKRenderer.swift
//  Canvas
//
//  Created by Limon on 9/1/16.
//  Copyright © 2016 Picasso. All rights reserved.
//

import GLKit

class GLKRenderer: NSObject, Renderable {

    let view: UIView

    let context: CIContext

    fileprivate var image: CIImage?

    init(GLContext: EAGLContext) {

        let colorSpace: CGColorSpace = CGColorSpace(name: CGColorSpace.sRGB) ?? CGColorSpaceCreateDeviceRGB()

        let options: [CIContextOption: Any] = [CIContextOption.workingColorSpace: colorSpace]
        context = CIContext(eaglContext: GLContext, options: options)

        let view = GLKView(frame: CGRect.zero, context: GLContext)
        view.contentScaleFactor = UIScreen.main.scale
        view.enableSetNeedsDisplay = true
        self.view = view

        super.init()

        view.delegate = self
    }

    func renderImage(_ image: CIImage) {
        self.image = image
        view.setNeedsDisplay()
    }
}

extension GLKRenderer: GLKViewDelegate {

    func glkView(_ view: GLKView, drawIn rect: CGRect) {

        guard let unwrappedImage = image else { return }

        glClearColor(0, 0, 0, 0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))

        let inRect = CGRect(origin: CGPoint.zero, size: rect.size.applying(CGAffineTransform(scaleX: view.contentScaleFactor, y: view.contentScaleFactor)))
        context.draw(unwrappedImage, in: inRect, from: unwrappedImage.extent)
    }
}
