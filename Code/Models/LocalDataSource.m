//
//  LocalDataSource.m
//  ShoeStorePrototype
//
//  Created by Paul Oostenrijk on 8/19/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "LocalDataSource.h"

#import "ProductInfo.h"
#import "ProductCategory.h"

@implementation LocalDataSource

- (void)getProductsByCategory:(ProductCategory *)category success:(ResponseSuccessBlock)success failure:(ResponseFailureBlock)failure {
  if (category.categoryId == 1) {
    // mens shoes
    success([self menProducts]);
  }
  else if (category.categoryId == 2) {
    // women shoes
    success([self womenProducts]);
  }
  else {
    failure([NSError errorWithDomain:@"LocalError" code:404 userInfo:@{}], @"Products not found");
  }
}

- (void)getProductsByCategory:(ProductCategory *)category searchFilter:(NSString *)filter success:(ResponseSuccessBlock)success failure:(ResponseFailureBlock)failure {
  
}


- (NSArray *)womenProducts {
  ProductInfo *product1 = [[ProductInfo alloc] init];
  product1.name = @"Women shoes";
  product1.content = @"Lorem ipsum dolor sit amet";
  product1.image = [UIImage imageNamed:@"men_shoes_1"];
  product1.price = 12.99f;
  
  return @[product1];
}

- (NSArray *)menProducts {
  ProductInfo *product1 = [[ProductInfo alloc] init];
  product1.name = @"Men shoes";
  product1.content = @"Lorem ipsum dolor sit amet";
  product1.image = [UIImage imageNamed:@"men_shoes_1"];
  product1.price = 12.99f;
  
  return @[product1];
}

@end
