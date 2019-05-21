//
//  Renderable.swift
//  Picasso
//
//  Created by Limon on 2016/8/13.
//  Copyright © 2016年 Picasso. All rights reserved.
//

import UIKit

public protocol Renderable {
    var view: UIView { get }

    func renderImage(_ image: CIImage)

    func renderPixelBuffer(_ pixelBuffer: CVPixelBuffer)
}

extension Renderable {

    public func renderImage(_ image: CIImage) {}

    public func renderPixelBuffer(_ pixelBuffer: CVPixelBuffer) {}
}
