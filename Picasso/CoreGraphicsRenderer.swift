//
//  CoreGraphicsRenderer.swift
//  Canvas
//
//  Created by Limon on 2016/8/13.
//  Copyright © 2016年 Picasso. All rights reserved.
//

import UIKit

struct CoreGraphicsRenderer: Renderer {

    let view: UIView

    let context: CIContext

    private var image: CIImage?

    init() {

        let colorSpace: CGColorSpace?

        if #available(iOS 9.0, *) {
            colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceSRGB)
        } else {
            colorSpace = CGColorSpaceCreateDeviceRGB()
        }

        view = UIImageView(frame: CGRectZero)

        let options: [String: AnyObject]? = colorSpace != nil ? [kCIContextWorkingColorSpace: colorSpace!] : nil
        context = CIContext(options: options)
    }

    func renderImage(image: CIImage) {
        let outputImage = context.createCGImage(image, fromRect: image.extent)
        (view as? UIImageView)?.image = UIImage(CGImage: outputImage)
    }

}
