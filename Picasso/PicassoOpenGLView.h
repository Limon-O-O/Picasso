//
//  FUOpenGLView.h
//  Picasso
//
//  Created by Limon F. on 11/4/2019.
//  Copyright © 2019 Picasso. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface PicassoOpenGLView : UIView

- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer;

- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer withLandmarks:(float *)landmarks count:(int)count;

@end
