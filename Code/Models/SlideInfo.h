//
//  SlideInfo.h
//  ShoeStorePrototype
//
//  Created by Paul Oostenrijk on 8/18/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlideInfo : NSObject

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *content;
@property (retain,nonatomic) UIImage *icon;
@property (retain,nonatomic) UIImage *background;


@end
