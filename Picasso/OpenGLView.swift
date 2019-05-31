//
//  OpenGLView.swift
//  Picasso
//
//  Created by Limon F. on 11/4/2019.
//  Copyright © 2019 Picasso. All rights reserved.
//

import UIKit

class OpenGLView: Renderable {

    var view: UIView

    init() {
        view = PicassoOpenGLView(frame: UIScreen.main.bounds)
        view.contentMode = UIView.ContentMode.scaleAspectFit
    }

    func renderImage(_ image: CIImage) {

    }

    func renderPixelBuffer(_ pixelBuffer: CVPixelBuffer) {
        (self.view as? PicassoOpenGLView)?.display(pixelBuffer)
    }
}
