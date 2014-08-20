//
//  ProductTableViewCell.h
//  ShoeStorePrototype
//
//  Created by Paul Oostenrijk on 8/19/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *availabilityLabel;

@end
