//
//  ProductInfo.h
//  ShoeStorePrototype
//
//  Created by Paul Oostenrijk on 8/19/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductInfo : NSObject

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) UIImage *image;
@property (strong,nonatomic) NSString *content;
@property (assign,nonatomic) CGFloat price;

@end
