//
//  ProductCategory.h
//  ShoeStorePrototype
//
//  Created by Paul Oostenrijk on 8/19/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductCategory : NSObject


@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) UIImage *categoryImage;
@property (assign,nonatomic) NSInteger categoryId;

@end
