//
//  OnboardSlideCollectionViewCell.h
//  ShoeStorePrototype
//
//  Created by Paul Oostenrijk on 8/18/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnboardSlideCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topPinIconImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topPinTextView;
@end
