//
//  OnboardingViewController.m
//  ShoeStorePrototype
//
//  Created by Paul Oostenrijk on 8/18/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "OnboardingViewController.h"
#import "SlideInfo.h"
#import "OnboardSlideCollectionViewCell.h"
#import <UIImageView+Ethanol.h>
#import "UIImage+ImageEffects.h"
#import "ProductCategory.h"
#import "CollectionViewController.h"

// scroll direction enum
typedef enum ScrollDirection {
  ScrollDirectionNone,
  ScrollDirectionRight,
  ScrollDirectionLeft,
  ScrollDirectionUp,
  ScrollDirectionDown,
  ScrollDirectionCrazy,
} ScrollDirection;

// animation of cell offset
static NSInteger kCellComponentAnimationOffset = 15;
static NSString *kCellIdentifier = @"SlideCell";

@interface OnboardingViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *backgroundImages;

@property (nonatomic, assign) CGFloat lastContentOffset;
@property (strong, nonatomic) UIImage *currentImage;
@property (nonatomic, assign) CGFloat kTopImagePin;
@property (nonatomic, assign) CGFloat kTopTextViewPin;


@end

@implementation OnboardingViewController


#pragma mark Initialization

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [self setupCollectionView];
}


- (void)setupCollectionView {
  
  // create a custom inset
  UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
  flow.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
  flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  flow.minimumInteritemSpacing = 0;
  flow.minimumLineSpacing = 0;
  
  self.collectionView.collectionViewLayout = flow;
  
  // set the collectionview delegate and datasource
  self.collectionView.dataSource = self;
  self.collectionView.delegate = self;
  
  // register nib
  [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([OnboardSlideCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
  
  self.pageControl.userInteractionEnabled = NO;
  
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self setupViewElements];
}

- (void)setupViewElements {
  // change background image to the first one
  SlideInfo *slide = [[self slideInfo] objectAtIndex:0];
  self.backgroundImageView.image = slide.background;
  
  [self.collectionView setContentOffset:CGPointMake(0, 0)];
  [self blurAndAnimateImage:slide.background];
  
  [self.pageControl setNumberOfPages:[self slideInfo].count];
}

- (void)viewDidAppear:(BOOL)animated {
  OnboardSlideCollectionViewCell *cell = (OnboardSlideCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
  [self animateComponentsInCell:cell];
}


- (NSArray *)slideInfo {
  SlideInfo *slide1 = [[SlideInfo alloc] init];
  slide1.title = @"ShoeStore Prototype";
  slide1.content = @"Ready to have the best experience during shopping at us? \n Let us guide you through our amazing app to get you started.";
  slide1.icon = [UIImage imageNamed:@"logo"];
  slide1.background = [UIImage imageNamed:@"background_1"];
  
  SlideInfo *slide2 = [[SlideInfo alloc] init];
  slide2.title = @"Meaningful Shopping";
  slide2.content = @"The app will give you products\nbased on your location.";
  slide2.icon = [UIImage imageNamed:@"pin_point"];
  slide2.background = [UIImage imageNamed:@"background_2"];
  
  
  SlideInfo *slide3 = [[SlideInfo alloc] init];
  slide3.title = @"Pay online";
  slide3.content = @"You like to have your \nshoes delivered home?\nWith our app you can easily buy\nyour shoes and get them delivered.";
  slide3.icon = [UIImage imageNamed:@"payment"];
  slide3.background = [UIImage imageNamed:@"background_1"];
  
  
  return @[slide1, slide2, slide3];
}

#pragma mark UICollectionViewDelegate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self slideInfo].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  OnboardSlideCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
  
  SlideInfo *slide = [[self slideInfo] objectAtIndex:indexPath.row];
  
  // set the values
  cell.titleLabel.text = slide.title;
  cell.contentTextView.text = slide.content;
  cell.iconImageView.image = slide.icon;
  
  cell.titleLabel.alpha = 0;
  cell.contentTextView.alpha = 0;
  cell.iconImageView.alpha = 0;
  
  self.kTopImagePin = cell.topPinIconImage.constant;
  self.kTopTextViewPin = cell.topPinTextView.constant;
  
  return cell;
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  ScrollDirection scrollDirection;
  if (self.lastContentOffset > scrollView.contentOffset.x)
    scrollDirection = ScrollDirectionRight;
  else if (self.lastContentOffset < scrollView.contentOffset.x)
    scrollDirection = ScrollDirectionLeft;
  
  self.lastContentOffset = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [self handleScrollViewAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
  [self handleScrollViewAnimation:scrollView];
}


- (void)handleScrollViewAnimation:(UIScrollView *)scrollView {
  UIImage *newImage;
  OnboardSlideCollectionViewCell *newCell;
  
  for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    SlideInfo *slide = [[self slideInfo] objectAtIndex:indexPath.row];
    
    if (slide) {
      newImage = slide.background;
      newCell = (OnboardSlideCollectionViewCell *)cell;
      [self.pageControl setCurrentPage:indexPath.row];
      
      break;
    }
  }
  
  if (self.currentImage.CGImage != newImage.CGImage) {
    self.currentImage = [newImage copy];
    [UIView transitionWithView:self.backgroundImageView
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                      self.backgroundImageView.image = newImage;
                    } completion:^(BOOL finished) {
                      [self blurAndAnimateImage:newImage];
                      [self animateComponentsInCell:newCell];
                    }];
  }
  
}


#pragma mark Custom methods
- (void)blurAndAnimateImage:(UIImage *)image {
  /// blur it and do it again
  [UIView transitionWithView:self.backgroundImageView
                    duration:0.5f
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
                    self.backgroundImageView.image = [image applyBlurWithRadius:10.0f tintColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1f] saturationDeltaFactor:1.0 maskImage:nil];
                  } completion:nil];
}

- (void)animateComponentsInCell:(OnboardSlideCollectionViewCell *)cell {
  
  cell.topPinIconImage.constant = self.kTopImagePin - kCellComponentAnimationOffset;
  cell.topPinTextView.constant = self.kTopTextViewPin + kCellComponentAnimationOffset;
  [cell layoutIfNeeded];
  
  [UIView animateWithDuration:0.3f delay:0.3f usingSpringWithDamping:1.0f initialSpringVelocity:0.2f options:UIViewAnimationOptionTransitionNone animations:^{
    cell.iconImageView.alpha = 1;
    cell.titleLabel.alpha = 1;
    cell.contentTextView.alpha = 1;
    cell.topPinIconImage.constant = self.kTopImagePin ;
    cell.topPinTextView.constant = self.kTopTextViewPin;
    [cell layoutIfNeeded];
    
  } completion:^(BOOL finished) {
    
  }];
  
}

#pragma mark IBOutlets

- (IBAction)getStartedPressed:(id)sender {
  ProductCategory *menCategory = [[ProductCategory alloc] init];
  menCategory.categoryId = 1;
  menCategory.categoryImage = [UIImage imageNamed:@"background_1"];
  menCategory.title = @"Men's shoes";
  
  
  CollectionViewController *collectionView = [[CollectionViewController alloc] initWithProductCategory:menCategory];
  UINavigationController *productNavigation = [[UINavigationController alloc] initWithRootViewController:collectionView];
  [self presentViewController:productNavigation animated:YES completion:nil];
}


@end
