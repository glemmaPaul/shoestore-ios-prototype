//
//  UIView+Ethanol.m
//  Ethanol
//
//  Created by Cameron Mulhern on 1/30/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "UIView+Ethanol.h"
#import <objc/runtime.h>

typedef void (^CompletionBlock)(void);

static NSString * const kParallaxSensitivityKey = @"parallaxSensitivity";

@implementation UIView (Ethanol)

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated {
  if (animated) {
    [self setHidden:hidden duration:0.3];
  } else {
    self.alpha = (hidden) ? 0.0f : 1.0f;
    self.hidden = hidden;
  }
}

- (void)setHidden:(BOOL)hidden duration:(NSTimeInterval)duration {
  [self setHidden:hidden duration:duration completion:nil];
}

- (void)setHidden:(BOOL)hidden duration:(NSTimeInterval)duration completion:(void (^)(void))completion {
  CompletionBlock completionWrapper = ^() {
    self.hidden = hidden;
    if (completion) {
      completion();
    }
  };
  
  if (!hidden) {
    self.hidden = NO;
  }
  
  CGFloat from = self.alpha;
  CGFloat to = (hidden) ? 0.0f : 1.0f;
  self.alpha = to;
  
  CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  alphaAnimation.fromValue = @(from);
  alphaAnimation.toValue = @(to);
  
  [CATransaction begin];
  [CATransaction setAnimationDuration:duration];
  [CATransaction setCompletionBlock:completionWrapper];
  [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
  [self.layer addAnimation:alphaAnimation forKey:@"alphaAnimation"];
  [CATransaction commit];
}

- (UIImage *)snapshot {
  UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0f);
  CGContextRef context = UIGraphicsGetCurrentContext();
  [self.layer renderInContext:context];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

- (void)addParallaxEffect {
  [self addMotionEffect:self.parallaxMotionEffect];
}

- (void)removeParallaxEffect {
  [self removeMotionEffect:self.parallaxMotionEffect];
}

static char parallaxMotionEffectKey;

- (UIMotionEffectGroup *)parallaxMotionEffect {
  UIMotionEffectGroup *effect = objc_getAssociatedObject(self, &parallaxMotionEffectKey);
  if (!effect) {
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    horizontalEffect.minimumRelativeValue = verticalEffect.minimumRelativeValue = @(-self.parallaxSensitivity);
    horizontalEffect.maximumRelativeValue = verticalEffect.maximumRelativeValue = @(self.parallaxSensitivity);
    group.motionEffects = @[horizontalEffect, verticalEffect];
    objc_setAssociatedObject(self, &parallaxMotionEffectKey, group, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    effect = group;
  }
  return effect;
}

static char parallaxSensitivityKey;

- (void)setParallaxSensitivity:(CGFloat)sensitivity {
  NSNumber *number = @(sensitivity);
  [self willChangeValueForKey:kParallaxSensitivityKey];
  objc_setAssociatedObject(self, &parallaxSensitivityKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  [self didChangeValueForKey:kParallaxSensitivityKey];
  for (UIInterpolatingMotionEffect *effect in self.parallaxMotionEffect.motionEffects) {
    effect.minimumRelativeValue = @(-sensitivity);
    effect.maximumRelativeValue = @(sensitivity);
  }
}

- (CGFloat)parallaxSensitivity {
  NSNumber *number = objc_getAssociatedObject(self, &parallaxSensitivityKey);
  return (number) ? [number floatValue] : 10.0f;
}

@end
