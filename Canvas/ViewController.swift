//
//  ViewController.swift
//  Canvas
//
//  Created by Limon on 2016/8/13.
//  Copyright © 2016年 Picasso. All rights reserved.
//

import UIKit
import Picasso

class ViewController: UIViewController {

    @IBOutlet private weak var canvas: Canvas!

    override func viewDidLoad() {
        super.viewDidLoad()
        canvas.canvasContentMode = .default
        canvas.image = CIImage(cgImage: UIImage(named: "StillLife")!.cgImage!)
    }
}

