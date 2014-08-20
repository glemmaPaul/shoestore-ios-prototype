//
//  DataSource.h
//  ShoeStorePrototype
//
//  Created by Paul Oostenrijk on 8/19/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductCategory;

typedef void (^ResponseSuccessBlock)(id result);
typedef void (^ResponseFailureBlock)(NSError *error, NSString *message);

@interface DataSource : NSObject


- (void)getProductsByCategory:(ProductCategory *)category
                      success:(ResponseSuccessBlock)success
                      failure:(ResponseFailureBlock)failure;

- (void)getProductsByCategory:(ProductCategory *)category
                 searchFilter:(NSString *)filter
                      success:(ResponseSuccessBlock)success
                      failure:(ResponseFailureBlock)failure;

@end
