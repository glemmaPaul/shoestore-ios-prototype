//
//  UIColor+Ethanol.h
//  Ethanol
//
//  Created by Cameron Mulhern on 1/30/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Ethanol)

/** Creates a new color from a hex formatted string (with or without the leading # or 0x).
 @param string The string to be converted.
 @return The created UIColor. Returns nil if the provided string is not a full 6 character, valid hex string.
 */
+ (UIColor *)colorWithHexString:(NSString *)string;

/** Returns the blue color used prominently in iOS 7 for borderless buttons etc.
 @return The UIColor.
 */
+ (UIColor *)ios7Blue;

@end
