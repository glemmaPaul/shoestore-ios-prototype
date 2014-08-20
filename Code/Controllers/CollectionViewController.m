//
//  CollectionViewController.m
//  ShoeStorePrototype
//
//  Created by Paul Oostenrijk on 8/19/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "CollectionViewController.h"
#import "ProductTableViewCell.h"
#import "ProductCategory.h"
#import "ProductHeaderView.h"
#import "UIImage+ImageEffects.h"

static NSString *kProductCellIdentifier = @"ProductCell";
static CGFloat kProductCellHeight = 68.0f;
static CGFloat kTableFooterHeight = 20.0f;
static CGFloat kHeaderImageParallaxEffect = 0.5f;
static CGFloat kTopImageTopOffset = 60.f;
static const CGFloat kTopImageOpacity = 0.3f;


@interface CollectionViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *headerLogo;
@property (strong,nonatomic) ProductCategory *category;

@end

@implementation CollectionViewController

- (id)initWithProductCategory:(ProductCategory *)category {
  self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
  
  if (self) {
    self.category = category;
  }
  
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [self setupTableView];
  [self setupViewElements];
  
}

- (void)setupTableView {
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  
  //register nib
  [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ProductTableViewCell class]) bundle:nil] forCellReuseIdentifier:kProductCellIdentifier];
  
  ProductHeaderView *headerView = [ProductHeaderView newInstance];
  self.tableView.tableHeaderView = headerView;
  
  self.headerLogo = headerView.headerImage;
  
  // create padding
  UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kTableFooterHeight)];
  self.tableView.tableFooterView = footerView;
  
}

- (void)setupViewElements {
  self.backgroundImageView.image = [self.category.categoryImage applyDarkEffect];
}



- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  // we don't want a navigation bar
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  // other views may need a navigation bar
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark TableView DataSource & Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ProductTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kProductCellIdentifier forIndexPath:indexPath];
  cell.backgroundColor = [UIColor clearColor];
  
  return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kProductCellHeight;
}

#pragma ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGRect imgRect = self.headerLogo.frame;
  imgRect.origin.y = kTopImageTopOffset - (-scrollView.contentOffset.y * kHeaderImageParallaxEffect);
  CGFloat opacityCalculation = (scrollView.contentOffset.y / kTopImageTopOffset) * kTopImageOpacity;
  self.headerLogo.alpha = 1 - opacityCalculation;
  
  self.headerLogo.frame = imgRect;
}

@end
