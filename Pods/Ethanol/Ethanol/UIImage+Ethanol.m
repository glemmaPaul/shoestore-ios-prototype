//
//  UIImage+Ethanol.m
//  Ethanol
//
//  Created by Cameron Mulhern on 1/30/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "UIImage+Ethanol.h"

typedef enum {
  ALPHA = 0,
  BLUE = 1,
  GREEN = 2,
  RED = 3
} PIXELS;

@implementation UIImage (Ethanol)

- (UIImage *)overlayWithColor:(UIColor *)color {
  return [self overlayWithColor:color blendMode:kCGBlendModeNormal];
}

- (UIImage *)overlayWithColor:(UIColor *)color blendMode:(CGBlendMode)blendMode {
  CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
  UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextTranslateCTM(context, 0.0f, rect.size.height);
  CGContextScaleCTM(context, 1.0f, -1.0f);
  CGContextDrawImage(context, rect, self.CGImage);
  CGContextSetBlendMode(context, blendMode);
  CGContextSetFillColorWithColor(context, color.CGColor);
  CGContextFillRect(context, rect);
  UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return result;
}

- (UIImage *)overlayWithImage:(UIImage *)image {
  return [self overlayWithImage:image blendMode:kCGBlendModeNormal];
}

- (UIImage *)overlayWithImage:(UIImage *)image blendMode:(CGBlendMode)blendMode {
  CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
  UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextTranslateCTM(context, 0.0f, rect.size.height);
  CGContextScaleCTM(context, 1.0f, -1.0f);
  CGContextDrawImage(context, rect, self.CGImage);
  CGContextSetBlendMode(context, blendMode);
  CGContextDrawImage(context, rect, image.CGImage);
  UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return result;
}

- (UIColor *)colorAtPoint:(CGPoint)point {
  CGSize size = self.size;
  CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
  if (!CGRectContainsPoint(rect, point)) return nil;
  
  NSInteger pointX = trunc(point.x);
  NSInteger pointY = trunc(point.y);
  
  CGImageRef image = self.CGImage;
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  unsigned char pixel[4] = {0, 0, 0, 0};
  
  CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
  CGColorSpaceRelease(colorSpace);
  
  CGContextSetBlendMode(context, kCGBlendModeCopy);
  CGContextTranslateCTM(context, -pointX, pointY - size.height + 1);
  CGContextDrawImage(context, rect, image);
  CGContextRelease(context);
  
  CGFloat red   = pixel[0] / 255.0f;
  CGFloat green = pixel[1] / 255.0f;
  CGFloat blue  = pixel[2] / 255.0f;
  CGFloat alpha = pixel[3] / 255.0f;
  return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIImage *)createThumbnailWithSize:(CGSize)size {
  return nil;
}

- (UIImage *)grayscaleImage {
  CGFloat scale = [[UIScreen mainScreen] scale];
  
  CGSize size = [self size];
  int width = size.width *scale;
  int height = size.height *scale;
  
  // the pixels will be painted to this array
  uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
  
  // clear the pixels so any transparency is preserved
  memset(pixels, 0, width * height * sizeof(uint32_t));
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  
  // create a context with RGBA pixels
  CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                               kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
  
  // paint the bitmap to our context which will fill in the pixels array
  CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
  
  for(int y = 0; y < height; y++) {
    for(int x = 0; x < width; x++) {
      uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
      
      // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
      float redConstant = 0.2126;
      float greenConstant = 0.7152;
      float blueConstant = 0.0722;
      uint32_t gray = redConstant * rgbaPixel[RED] + greenConstant * rgbaPixel[GREEN] + blueConstant * rgbaPixel[BLUE];
      
      // set the pixels to gray
      rgbaPixel[RED] = gray;
      rgbaPixel[GREEN] = gray;
      rgbaPixel[BLUE] = gray;
    }
  }
  
  // create a new CGImageRef from our context with the modified pixels
  CGImageRef image = CGBitmapContextCreateImage(context);
  
  // we're done with the context, color space, and pixels
  CGContextRelease(context);
  CGColorSpaceRelease(colorSpace);
  free(pixels);
  
  // make a new UIImage to return
  UIImage *resultUIImage = [UIImage imageWithCGImage:image scale:scale orientation:UIImageOrientationUp];
  
  // we're done with image now too
  CGImageRelease(image);
  
  return resultUIImage;
}

- (UIImage *)cropToRect:(CGRect)rect {
  CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
  UIImage * finalImage = [[UIImage alloc]initWithCGImage:imageRef];
  CGImageRelease(imageRef);
  return finalImage;
}

- (UIImage *)cropToCircle {
  return [self cropToCircleWithRadius:MIN(self.size.width, self.size.height)/2];
}

- (UIImage *)cropToCircleWithRadius:(float)radius {
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.width, self.size.height), NO, 0.0);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  //Calculate the centre of the circle
  CGFloat imageCentreX = self.size.width / 2;
  CGFloat imageCentreY = self.size.height / 2;

  // Create and CLIP to a CIRCULAR Path
  // (This could be replaced with any closed path if you want a different shaped clip)
  CGContextBeginPath (context);
  CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
  CGContextClosePath (context);
  CGContextClip (context);
  
  CGRect positionRect = CGRectMake(0, 0, self.size.width, self.size.height);
  [self drawInRect:positionRect];
  
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return newImage;
}

// Returns true if the image has an alpha layer
- (BOOL)hasAlpha {
  CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
  return (alpha == kCGImageAlphaFirst ||
          alpha == kCGImageAlphaLast ||
          alpha == kCGImageAlphaPremultipliedFirst ||
          alpha == kCGImageAlphaPremultipliedLast);
}

// Returns a copy of the given image, adding an alpha channel if it doesn't already have one
- (UIImage *)imageWithAlpha {
  if ([self hasAlpha]) {
    return self;
  }
  
  CGImageRef imageRef = self.CGImage;
  size_t width = CGImageGetWidth(imageRef);
  size_t height = CGImageGetHeight(imageRef);
  
  // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
  CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                        width,
                                                        height,
                                                        8,
                                                        0,
                                                        CGImageGetColorSpace(imageRef),
                                                        kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
  
  // Draw the image into the context and retrieve the new image, which will now have an alpha layer
  CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
  CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
  UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];
  
  // Clean up
  CGContextRelease(offscreenContext);
  CGImageRelease(imageRefWithAlpha);
  
  return imageWithAlpha;
}

// Returns a copy of the image with a transparent border of the given size added around its edges.
// If the image has no alpha layer, one will be added to it.
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize {
  // If the image does not have an alpha layer, add one
  UIImage *image = [self imageWithAlpha];
  
  CGRect newRect = CGRectMake(0, 0, image.size.width + borderSize * 2, image.size.height + borderSize * 2);
  
  // Build a context that's the same dimensions as the new size
  CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                              newRect.size.width,
                                              newRect.size.height,
                                              CGImageGetBitsPerComponent(self.CGImage),
                                              0,
                                              CGImageGetColorSpace(self.CGImage),
                                              CGImageGetBitmapInfo(self.CGImage));
  
  // Draw the image in the center of the context, leaving a gap around the edges
  CGRect imageLocation = CGRectMake(borderSize, borderSize, image.size.width, image.size.height);
  CGContextDrawImage(bitmap, imageLocation, self.CGImage);
  CGImageRef borderImageRef = CGBitmapContextCreateImage(bitmap);
  
  // Create a mask to make the border transparent, and combine it with the image
  CGImageRef maskImageRef = [self newBorderMask:borderSize size:newRect.size];
  CGImageRef transparentBorderImageRef = CGImageCreateWithMask(borderImageRef, maskImageRef);
  UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef];
  
  // Clean up
  CGContextRelease(bitmap);
  CGImageRelease(borderImageRef);
  CGImageRelease(maskImageRef);
  CGImageRelease(transparentBorderImageRef);
  
  return transparentBorderImage;
}

// Creates a copy of this image with rounded corners
// If borderSize is non-zero, a transparent border of the given size will also be added
// Original author: BjÃ¶rn SÃ¥llarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize {
  // If the image does not have an alpha layer, add one
  UIImage *image = [self imageWithAlpha];
  
  // Build a context that's the same dimensions as the new size
  CGContextRef context = CGBitmapContextCreate(NULL,
                                               image.size.width,
                                               image.size.height,
                                               CGImageGetBitsPerComponent(image.CGImage),
                                               0,
                                               CGImageGetColorSpace(image.CGImage),
                                               CGImageGetBitmapInfo(image.CGImage));
  
  // Create a clipping path with rounded corners
  CGContextBeginPath(context);
  [self addRoundedRectToPath:CGRectMake(borderSize, borderSize, image.size.width - borderSize * 2, image.size.height - borderSize * 2)
                     context:context
                   ovalWidth:cornerSize
                  ovalHeight:cornerSize];
  CGContextClosePath(context);
  CGContextClip(context);
  
  // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
  CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
  
  // Create a CGImage from the context
  CGImageRef clippedImage = CGBitmapContextCreateImage(context);
  CGContextRelease(context);
  
  // Create a UIImage from the CGImage
  UIImage *roundedImage = [UIImage imageWithCGImage:clippedImage];
  CGImageRelease(clippedImage);
  
  return roundedImage;
}

// Creates a mask that makes the outer edges transparent and everything else opaque
// The size must include the entire mask (opaque part + transparent border)
// The caller is responsible for releasing the returned reference by calling CGImageRelease
- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size {
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
  
  // Build a context that's the same dimensions as the new size
  CGContextRef maskContext = CGBitmapContextCreate(NULL,
                                                   size.width,
                                                   size.height,
                                                   8, // 8-bit grayscale
                                                   0,
                                                   colorSpace,
                                                   kCGBitmapByteOrderDefault | kCGImageAlphaNone);
  
  // Start with a mask that's entirely transparent
  CGContextSetFillColorWithColor(maskContext, [UIColor blackColor].CGColor);
  CGContextFillRect(maskContext, CGRectMake(0, 0, size.width, size.height));
  
  // Make the inner part (within the border) opaque
  CGContextSetFillColorWithColor(maskContext, [UIColor whiteColor].CGColor);
  CGContextFillRect(maskContext, CGRectMake(borderSize, borderSize, size.width - borderSize * 2, size.height - borderSize * 2));
  
  // Get an image of the context
  CGImageRef maskImageRef = CGBitmapContextCreateImage(maskContext);
  
  // Clean up
  CGContextRelease(maskContext);
  CGColorSpaceRelease(colorSpace);
  
  return maskImageRef;
}

// Returns a copy of this image that is squared to the thumbnail size.
// If transparentBorder is non-zero, a transparent border of the given size will be added around the edges of the thumbnail. (Adding a transparent border of at least one pixel in size has the side-effect of antialiasing the edges of the image when rotating it using Core Animation.)
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality {
  UIImage *resizedImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                     bounds:CGSizeMake(thumbnailSize, thumbnailSize)
                                       interpolationQuality:quality];
  
  // Crop out any part of the image that's larger than the thumbnail size
  // The cropped rect must be centered on the resized image
  // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
  CGRect cropRect = CGRectMake(round((resizedImage.size.width - thumbnailSize) / 2),
                               round((resizedImage.size.height - thumbnailSize) / 2),
                               thumbnailSize,
                               thumbnailSize);
  UIImage *croppedImage = [resizedImage cropToRect:cropRect];
  
  UIImage *transparentBorderImage = borderSize ? [croppedImage transparentBorderImage:borderSize] : croppedImage;
  
  return [transparentBorderImage roundedCornerImage:cornerRadius borderSize:borderSize];
}

- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
  BOOL drawTransposed;
  
  switch (self.imageOrientation) {
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      drawTransposed = YES;
      break;
      
    default:
      drawTransposed = NO;
  }
  
  return [self resizedImage:newSize
                  transform:[self transformForOrientation:newSize]
             drawTransposed:drawTransposed
       interpolationQuality:quality];
}

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality {
  CGFloat horizontalRatio = bounds.width / self.size.width;
  CGFloat verticalRatio = bounds.height / self.size.height;
  CGFloat ratio;
  
  switch (contentMode) {
    case UIViewContentModeScaleAspectFill:
      ratio = MAX(horizontalRatio, verticalRatio);
      break;
      
    case UIViewContentModeScaleAspectFit:
      ratio = MIN(horizontalRatio, verticalRatio);
      break;
      
    default:
      [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %ld", (unsigned long)contentMode];
  }
  
  CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
  
  return [self resizedImage:newSize interpolationQuality:quality];
}

#pragma mark - Private Helpers

// Adds a rectangular path to the given context and rounds its corners by the given extents
// Original author: BjÃ¶rn SÃ¥llarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
- (void)addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight {
  if (ovalWidth == 0 || ovalHeight == 0) {
    CGContextAddRect(context, rect);
    return;
  }
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
  CGContextScaleCTM(context, ovalWidth, ovalHeight);
  CGFloat fw = CGRectGetWidth(rect) / ovalWidth;
  CGFloat fh = CGRectGetHeight(rect) / ovalHeight;
  CGContextMoveToPoint(context, fw, fh/2);
  CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
  CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
  CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
  CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
  CGContextClosePath(context);
  CGContextRestoreGState(context);
}

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
  CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
  CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
  CGImageRef imageRef = self.CGImage;
  
  // Build a context that's the same dimensions as the new size
  CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                              newRect.size.width,
                                              newRect.size.height,
                                              CGImageGetBitsPerComponent(imageRef),
                                              0,
                                              CGImageGetColorSpace(imageRef),
                                              CGImageGetBitmapInfo(imageRef));
  
  // Rotate and/or flip the image if required by its orientation
  CGContextConcatCTM(bitmap, transform);
  
  // Set the quality level to use when rescaling
  CGContextSetInterpolationQuality(bitmap, quality);
  
  // Draw into the context; this scales the image
  CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
  
  // Get the resized image from the context and a UIImage
  CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
  UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
  
  // Clean up
  CGContextRelease(bitmap);
  CGImageRelease(newImageRef);
  
  return newImage;
}

- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
  CGAffineTransform transform = CGAffineTransformIdentity;
  
  switch (self.imageOrientation) {
    case UIImageOrientationDown:           // EXIF = 3
    case UIImageOrientationDownMirrored:   // EXIF = 4
      transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
      transform = CGAffineTransformRotate(transform, M_PI);
      break;
      
    case UIImageOrientationLeft:           // EXIF = 6
    case UIImageOrientationLeftMirrored:   // EXIF = 5
      transform = CGAffineTransformTranslate(transform, newSize.width, 0);
      transform = CGAffineTransformRotate(transform, M_PI_2);
      break;
      
    case UIImageOrientationRight:          // EXIF = 8
    case UIImageOrientationRightMirrored:  // EXIF = 7
      transform = CGAffineTransformTranslate(transform, 0, newSize.height);
      transform = CGAffineTransformRotate(transform, -M_PI_2);
      break;
      
    default:
      break; // Prevents warning
  }
  
  switch (self.imageOrientation) {
    case UIImageOrientationUpMirrored:     // EXIF = 2
    case UIImageOrientationDownMirrored:   // EXIF = 4
      transform = CGAffineTransformTranslate(transform, newSize.width, 0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;
      
    case UIImageOrientationLeftMirrored:   // EXIF = 5
    case UIImageOrientationRightMirrored:  // EXIF = 7
      transform = CGAffineTransformTranslate(transform, newSize.height, 0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;
      
    default:
      break; // Prevents warning
  }
  
  return transform;
}

@end
