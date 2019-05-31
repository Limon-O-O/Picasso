//
//  Canvas.swift
//  Picasso
//
//  Created by Limon on 2016/8/13.
//  Copyright © 2016年 Picasso. All rights reserved.
//

import UIKit
import AVFoundation.AVUtilities

public enum CanvasContentMode {
    case `default`
    case scaleAspectFit
    case scaleAspectFill
    case center
}

open class Canvas: UIView {

    private let screenScaleFactor = UIScreen.main.nativeScale

    private var renderer: Renderable?

    /// 由于 pixelBuffer 速度较快，需要，确保 renderer 只添加一次到 super view
    private var didGeneratedRenderer: Bool = false

    open var image: CIImage? {
        didSet {
            guard oldValue != image else { return }
            setNeedsLayout()
        }
    }

    open var pixelBuffer: CVPixelBuffer? {
        didSet {
            guard oldValue != pixelBuffer else { return }
            guard let pixelBuffer = pixelBuffer else { return }
            if renderer == nil, !didGeneratedRenderer {
                // 由于 pixelBuffer 速度较快，需要确保 renderer 只添加一次到 super view
                didGeneratedRenderer = true
                DispatchQueue.main.async() {
                    let suggestedRenderer = Canvas.suggestedRenderer()
                    suggestedRenderer.view.frame = self.bounds.integral
                    self.renderer = suggestedRenderer
                    self.addSubview(suggestedRenderer.view)
                    self.renderer?.renderPixelBuffer(pixelBuffer)
                }
            } else {
                renderer?.renderPixelBuffer(pixelBuffer)
            }
        }
    }

    open var canvasContentMode: CanvasContentMode = .default {
        didSet {
            guard oldValue != canvasContentMode else { return }
            setNeedsLayout()
        }
    }

    private class func suggestedRenderer() -> Renderable {

//        #if !(arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
//        if let defaultDevice = MTLCreateSystemDefaultDevice(), let metalRenderer = MetalRenderer(device: defaultDevice) {
//            return metalRenderer
//        }
//        #endif

        return OpenGLView()//GLKRenderer(GLContext: EAGLContext(api: .openGLES2)!)
    }

    private func makeRectWithAspectRatioFillRect(_ aspectRatio: CGSize, boundingRect: CGRect) -> CGRect {

        let horizontalRatio = boundingRect.size.width / aspectRatio.width
        let verticalRatio = boundingRect.size.height / aspectRatio.height

        let ratio = max(horizontalRatio, verticalRatio)

        let newSize = CGSize(width: aspectRatio.width * ratio, height: aspectRatio.height * ratio)

        let rect = CGRect(x: boundingRect.origin.x + (boundingRect.size.width - newSize.width)/2, y: boundingRect.origin.y + (boundingRect.size.height - newSize.height)/2, width: newSize.width, height: newSize.height)
        return rect.integral
    }

    private func makeRectWithAspectRatioInsideRect(_ aspectRatio: CGSize, boundingRect: CGRect) -> CGRect {
        return AVMakeRect(aspectRatio: aspectRatio, insideRect: boundingRect)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        guard let renderer = renderer else { return }

        if let unwrappedImage = image {
            let imageSize = unwrappedImage.extent.size

            if (imageSize.equalTo(CGSize.zero) || bounds.size.equalTo(CGSize.zero)) {
                return
            }

            switch canvasContentMode {

            case .scaleAspectFill:
                renderer.view.frame = makeRectWithAspectRatioFillRect(imageSize, boundingRect: bounds)

            case .scaleAspectFit:
                renderer.view.frame = makeRectWithAspectRatioInsideRect(imageSize, boundingRect: bounds)

            case .center:
                let viewSize = CGSize(width: imageSize.width/screenScaleFactor, height: imageSize.height/screenScaleFactor)
                renderer.view.frame = CGRect(x: (bounds.width - viewSize.width)/2, y: (bounds.height - viewSize.height)/2, width: viewSize.width, height: viewSize.height).integral

            case .`default`:
                renderer.view.frame = bounds.integral
            }

            updateContent()
        } else if renderer.view.frame != bounds.integral {
            renderer.view.frame = bounds.integral
            updateContent()
        }
    }

    private func updateContent() {
        if let unwrappedImage = image {
            let scaledImage = scaleImageForDisplay(unwrappedImage)
            renderer?.renderImage(scaledImage)
        } else if let pixelBuffer = pixelBuffer {
            renderer?.renderPixelBuffer(pixelBuffer)
        }
    }

    private func scaleImageForDisplay(_ image: CIImage) -> CIImage {

        let scaledBounds = self.bounds.applying(CGAffineTransform(scaleX: screenScaleFactor, y: screenScaleFactor))
        let imageSize = image.extent.size

        switch canvasContentMode {
        case .scaleAspectFill:
            let targetRect = makeRectWithAspectRatioFillRect(imageSize, boundingRect: scaledBounds)
            let horizontalScale = targetRect.size.width / imageSize.width
            let verticalScale = targetRect.size.height / imageSize.height
            return image.transformed(by: CGAffineTransform(scaleX: horizontalScale, y: verticalScale))

        case .scaleAspectFit:
            let targetRect = makeRectWithAspectRatioInsideRect(imageSize, boundingRect: scaledBounds)
            let horizontalScale = targetRect.size.width / imageSize.width
            let verticalScale = targetRect.size.height / imageSize.height
            return image.transformed(by: CGAffineTransform(scaleX: horizontalScale, y: verticalScale))

        default:
            return image
        }
    }
}
