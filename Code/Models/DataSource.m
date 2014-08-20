//
//  DataSource.m
//  ShoeStorePrototype
//
//  Created by Paul Oostenrijk on 8/19/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource

#pragma mark Public methods

- (void)getProductsByCategory:(ProductCategory *)category searchFilter:(NSString *)filter success:(ResponseSuccessBlock)success failure:(ResponseFailureBlock)failure {
  [self raiseImplementException:__PRETTY_FUNCTION__];
}

- (void)getProductsByCategory:(ProductCategory *)category success:(ResponseSuccessBlock)success failure:(ResponseFailureBlock)failure {
  [self raiseImplementException:__PRETTY_FUNCTION__];
}

#pragma mark Private methods

- (void)raiseImplementException:(const char[41])function {
  [NSException raise:@"Method not overidden" format:@"Method %s isn't overidden in the child class", function];
}



@end
