//
//  UIView+Ethanol.h
//  Ethanol
//
//  Created by Cameron Mulhern on 1/30/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Ethanol)

/** Shows or hides a view optionally using a fade animation.
 @param hidden Indicates whether to hide or show the view.
 @param animated Determines if the transition should be animated.
 */
- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;

/** Shows or hides a view optionally using a fade animation.
 @param hidden Indicates whether to hide or show the view.
 @param duration The duration of the fade animation.
 */
- (void)setHidden:(BOOL)hidden duration:(NSTimeInterval)duration;

/** Shows or hides a view optionally using a fade animation.
 @param hidden Indicates whether to hide or show the view.
 @param animated The duration of the fade animation.
 @param completion A block to be executed when the animation completes.
 */
- (void)setHidden:(BOOL)hidden duration:(NSTimeInterval)duration completion:(void (^)(void))completion;

/** Renders the UIView and captures it as a UIImage.
 @return The view snapshot.
 */
- (UIImage *)snapshot;

/** Adds a parallax effect to the UIView.
 */
- (void)addParallaxEffect;

/** Removes the parallax effect from the UIView.
 */
- (void)removeParallaxEffect;

/** Sets the sensitivity of the parallax motion effect.
 @param sensitivity The desired sensitivity.
 */
- (void)setParallaxSensitivity:(CGFloat)sensitivity;

/** Gets the sensitivity of the parallax motion effect.
 @return The current parallax sensitivity.
 */
- (CGFloat)parallaxSensitivity;

@end
