//
//  NSString+Ethanol.m
//  Ethanol
//
//  Created by Cameron Mulhern on 1/30/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "NSString+Ethanol.h"
#import <CommonCrypto/CommonCrypto.h>

static NSString * const kAlphabeticRegEx = @"[a-zA-Z\\s]";
static NSString * const kAlphaNumericRegEx = @"[a-zA-Z0-9\\s]";
static NSString * const kEmailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

@implementation NSString (Ethanol)

#pragma mark - General
- (BOOL)containsSubstring:(NSString *)substring {
  NSRange range = [self rangeOfString:substring];
  return (range.location != NSNotFound);
}

#pragma mark - Validation
- (BOOL)isNonempty {
  return self.length != 0;
}

- (BOOL)isAlphabetic {
  if (nil == self || [self isEqualToString:@""])
    return NO;
  NSRegularExpression *regex =
  [NSRegularExpression regularExpressionWithPattern:kAlphabeticRegEx
                                            options:0
                                              error:nil];
  NSUInteger numberOfMatches =
  [regex numberOfMatchesInString:self
                         options:0
                           range:NSMakeRange(0, self.length)];
  return numberOfMatches == self.length;
}

- (BOOL)isNumeric {
  if (nil == self || [self isEqualToString: @""])
    return NO;
  NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
  return ([self rangeOfCharacterFromSet:notDigits].location == NSNotFound);
}

- (BOOL)isAlphanumeric {
  if (nil == self || [self isEqualToString: @""])
    return NO;
  
  NSRegularExpression *regex =
  [NSRegularExpression regularExpressionWithPattern:kAlphaNumericRegEx
                                            options:0
                                              error:nil];
  NSUInteger numberOfMatches =
  [regex numberOfMatchesInString:self
                         options:0
                           range:NSMakeRange(0, self.length)];
  
  return numberOfMatches == self.length;
}

- (BOOL)isValidEmail {
  NSString *emailRegex = kEmailRegEx;
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",
                            emailRegex];
  return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidURL {
  NSURL *URL = [NSURL URLWithString:self];
  if (URL && URL.scheme && URL.host) {
    return YES;
  } else {
    return NO;
  }
}

- (BOOL)isValidPassword {
  return self.length >= 6;
}

#pragma mark - Security/Crypto
- (NSString *)MD5 {
  const char *cStr = [self UTF8String];
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  
  CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
  
  return [NSString stringWithFormat:
          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
          result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
          result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
          ];
}

- (NSString *)SHA1 {
  NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
  uint8_t digest[CC_SHA1_DIGEST_LENGTH];
  CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
  NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
  for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
    [output appendFormat:@"%02x", digest[i]];
  }
  return output;
}

@end
