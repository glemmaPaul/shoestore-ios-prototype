//
//  ProductHeaderView.m
//  ShoeStorePrototype
//
//  Created by Paul Oostenrijk on 8/19/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "ProductHeaderView.h"

@implementation ProductHeaderView

+ (ProductHeaderView *)newInstance {
  ProductHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ProductHeaderView class]) owner:nil options:nil] firstObject];
  
  return headerView;
}



@end
