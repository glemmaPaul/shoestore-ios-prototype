//
//  CustomButton.m
//  ShoeStorePrototype
//
//  Created by Paul Oostenrijk on 8/18/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (id)init {
  self = [super init];
  
  if (self) {
    [self setupButton];
  }
  
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self setupButton];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  
  if (self) {
    [self setupButton];
  }
  
  return self;
}

- (void)setupButton {
  self.layer.cornerRadius = 4.0f;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
