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
    case Default
    case ScaleAspectFit
    case ScaleAspectFill
    case Center
}

public class Canvas: UIView {

    public var renderer: Renderer = Canvas.suggestedRenderer() {
        didSet {
            oldValue.view.removeFromSuperview()
            renderer.view.frame = CGRectIntegral(bounds)
            addSubview(renderer.view)
        }
    }

    public var image: CIImage = CIImage() {
        didSet {
            guard oldValue != image else { return }
            setNeedsLayout()
        }
    }

    public var canvasContentMode: CanvasContentMode = .Default {
        didSet {
            guard oldValue != canvasContentMode else { return }
            setNeedsLayout()
        }
    }

    public class func suggestedRenderer() -> Renderer {
        return CoreGraphicsRenderer()!
    }

    private let screenScaleFactor = UIScreen.mainScreen().nativeScale

    private func makeRectWithAspectRatioFillRect(aspectRatio: CGSize, boundingRect: CGRect) -> CGRect {

        let horizontalRatio = boundingRect.size.width / aspectRatio.width
        let verticalRatio = boundingRect.size.height / aspectRatio.height

        let ratio = max(horizontalRatio, verticalRatio)
        //ratio = MIN(horizontalRatio, verticalRatio)

        let newSize = CGSizeMake(aspectRatio.width * ratio, aspectRatio.height * ratio)

        let rect = CGRectMake(boundingRect.origin.x + (boundingRect.size.width - newSize.width)/2, boundingRect.origin.y + (boundingRect.size.height - newSize.height)/2, newSize.width, newSize.height)
        return CGRectIntegral(rect)
    }

    private func makeRectWithAspectRatioInsideRect(aspectRatio: CGSize, boundingRect: CGRect) -> CGRect {
        return AVMakeRectWithAspectRatioInsideRect(aspectRatio, boundingRect)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        let imageSize = image.extent.size

        if (CGSizeEqualToSize(imageSize, CGSizeZero) || CGSizeEqualToSize(bounds.size, CGSizeZero)) {
            return
        }

        switch canvasContentMode {

        case .ScaleAspectFill:
            renderer.view.frame = makeRectWithAspectRatioFillRect(imageSize, boundingRect: bounds)

        case .ScaleAspectFit:
            renderer.view.frame = makeRectWithAspectRatioInsideRect(imageSize, boundingRect: bounds)

        case .Center:
            let viewSize = CGSizeMake(imageSize.width/screenScaleFactor, imageSize.height/screenScaleFactor)
            renderer.view.frame = CGRectIntegral(CGRectMake((CGRectGetWidth(bounds) - viewSize.width)/2, (CGRectGetHeight(bounds) - viewSize.height)/2, viewSize.width, viewSize.height))

        default:
            renderer.view.frame = CGRectIntegral(bounds)
        }

        updateContent()
    }

    private func updateContent() {

    }

}
