//
//  UIImageView+Ethanol.m
//  Ethanol
//
//  Created by Cameron Mulhern on 1/30/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "UIImageView+Ethanol.h"

@implementation UIImageView (Ethanol)

- (void)setImage:(UIImage *)image animated:(BOOL)animated {
  if (animated) {
    [self setImage:image duration:0.3];
  } else {
    self.image = image;
  }
}

- (void)setImage:(UIImage *)image duration:(NSTimeInterval)duration {
  [self setImage:image duration:duration completion:nil];
}

- (void)setImage:(UIImage *)image duration:(NSTimeInterval)duration completion:(void (^)(void))completion {
  if (self.image == image) return;
  
  CATransition *transition = [CATransition animation];
  transition.type = kCATransitionFade;
  
  [CATransaction begin];
  [CATransaction setAnimationDuration:duration];
  [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
  [CATransaction setCompletionBlock:completion];
  [self.layer addAnimation:transition forKey:nil];
  self.image = image;
  [CATransaction commit];
}

@end
