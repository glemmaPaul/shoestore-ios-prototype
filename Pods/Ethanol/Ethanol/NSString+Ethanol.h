//
//  NSString+Ethanol.h
//  Ethanol
//
//  Created by Cameron Mulhern on 1/30/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Ethanol)

// General
/**
 Returns YES if the string contains the given substring, otherwise returns NO.
 @param substring The substring to check for
 @return A BOOL describing whether or not the string contains the substring.
 */
- (BOOL)containsSubstring:(NSString *)substring;

// Validation
/**
 Returns YES if the string is not empty, otherwise returns NO.
 @return A BOOL describing whether or not the string is not empty.
 */
- (BOOL)isNonempty;
/**
 Returns YES if the string is made up of alphabetic characters (a-z, A-Z), otherwise NO.
 @return A BOOL describing whether or not the string is alphabetic.
 */
- (BOOL)isAlphabetic;
/**
 Returns YES if the string is made up of number characters (0-9), otherwise NO.
 @return A BOOL describing whether or not the string is numeric.
 */
- (BOOL)isNumeric;
/**
 Returns YES if the string is made up of alphanumeric characters (a-z, A-Z, 0-9), otherwise NO.
 @return A BOOL describing whether or not the string is alphanumeric.
 */
- (BOOL)isAlphanumeric;
/**
 Returns YES if the string is a valid email address, otherwise NO.
 @return A BOOL describing whether or not the string is a valid email address.
 */
- (BOOL)isValidEmail;
/**
 Returns YES if the string is a valid URL, otherwise NO.
 @return A BOOL describing whether or not the string is a valid URL.
 */
- (BOOL)isValidURL;
/**
 Returns YES if the string is a valid password (6 or more characters), otherwise NO.
 @return A BOOL describing whether or not the string is a valid password.
 */
- (BOOL)isValidPassword;


// Security/Crypto
/**
 Returns an MD5 hash of the given string.
 @return The MD5 hash string
 */
- (NSString *)MD5;
/**
 Returns an SHA-1 hash of the given string.
 @return The SHA-1 hash string
 */
- (NSString *)SHA1;


@end
