//
//  UIImageView+Ethanol.h
//  Ethanol
//
//  Created by Cameron Mulhern on 1/30/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Ethanol)

/** Sets the image optionally using a fade animation.
 @param image The image to be set.
 @param animated Determines if the transition should be animated.
 */
- (void)setImage:(UIImage *)image animated:(BOOL)animated;

/** Sets the image optionally using a fade animation.
 @param image The image to be set.
 @param duration The duration of the fade animation.
 */
- (void)setImage:(UIImage *)image duration:(NSTimeInterval)duration;

/** Sets the image optionally using a fade animation.
 @param image The image to be set.
 @param animated The duration of the fade animation.
 @param completion A block to be executed when the animation completes.
 */
- (void)setImage:(UIImage *)image duration:(NSTimeInterval)duration completion:(void (^)(void))completion;

@end
