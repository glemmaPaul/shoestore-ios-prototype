//
//  CollectionViewController.h
//  ShoeStorePrototype
//
//  Created by Paul Oostenrijk on 8/19/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductCategory;

@interface CollectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

- (id)initWithProductCategory:(ProductCategory *)category;

@end
