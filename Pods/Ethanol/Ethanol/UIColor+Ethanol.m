//
//  UIColor+Ethanol.m
//  Ethanol
//
//  Created by Cameron Mulhern on 1/30/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "UIColor+Ethanol.h"

@implementation UIColor (Ethanol)

+ (UIColor *)colorWithHexString:(NSString *)string {
  if ([string hasPrefix:@"#"]) {
    string = [string substringFromIndex:1];
  }
  else if ([string hasPrefix:@"0x"]) {
    string = [string substringFromIndex:2];
  }
  
  if (string.length == 0 || string.length > 6) return nil;
  
  string = [string stringByPaddingToLength:6 withString:@"0" startingAtIndex:0];
  
  NSCharacterSet *chars = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890ABCDEFabcdef"] invertedSet];
  if ([string rangeOfCharacterFromSet:chars].location != NSNotFound) {
    return nil;
  }
  
  unsigned int rgbValue;
  NSScanner *scanner = [NSScanner scannerWithString:string];
  scanner.scanLocation = 0;
  [scanner scanHexInt:&rgbValue];
  return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                         green:((rgbValue & 0xFF00) >> 8) / 255.0f
                          blue:((rgbValue & 0xFF) >> 0) / 255.0f
                         alpha:1.0f];
}

+ (UIColor *)ios7Blue {
  static UIColor *color;
  if (!color) color = [UIColor colorWithRed:0.0f green:122.0f/255.0f blue:1.0f alpha:1.0f];
  return color;
}

@end
