//
//  CoreGraphicsRenderer.swift
//  Canvas
//
//  Created by Limon on 2016/8/13.
//  Copyright © 2016年 Picasso. All rights reserved.
//

import UIKit

struct CoreGraphicsRenderer: Renderer {

    let view: UIImageView

    let context: CIContext

    init?() {

        let colorSpace: CGColorSpace?

        if #available(iOS 9.0, *) {
            colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceSRGB)
        } else {
            colorSpace = CGColorSpaceCreateDeviceRGB()
        }

        guard let unwrappedColorSpace = colorSpace else { return nil }

        view = UIImageView(frame: CGRectZero)

        let options = [kCIContextWorkingColorSpace: unwrappedColorSpace]
        context = CIContext(options: options)
    }

    func renderImage(image: CIImage) {
        let outputImage = context.createCGImage(image, fromRect: image.extent)
//        view.layer.contents = outputImage
        view.image = UIImage(CGImage: outputImage)
    }

}
