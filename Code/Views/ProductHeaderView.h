//
//  ProductHeaderView.h
//  ShoeStorePrototype
//
//  Created by Paul Oostenrijk on 8/19/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductHeaderView : UIView

+ (ProductHeaderView *)newInstance;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

@end
