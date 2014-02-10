//
//  ETHAlertView.m
//  Ethanol
//
//  Created by Cameron Mulhern on 1/31/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "ETHAlertView.h"

#pragma mark - Alert View Attributes

#define kAlertViewWidth 280
#define kMaxLabelWidth 240
#define kMaxLabelHeight 200
#define kTopStripeHeight 20
#define kBorderWidth 20
#define kFadedViewAlpha 0.7
#define kTitleTopSpace 30
#define kMessageTopSpace 10
#define kButtonTopSpace 20
#define kSmallButtonWidth 125
#define kLargeButtonWidth 260
#define kButtonXoffset 10
#define kButtonHeight 40
#define kVerticalButtonGap 10
#define kAnimationDuration 0.2

#pragma mark - Custom Property Keys

#define kBackgroundColorKey @"backgroundColor"
#define kTitleColorKey @"titleColor"
#define kTitleFontNameKey @"titleFontName"
#define kTitleFontSizeKey @"titleFontSize"
#define kMessageColorKey @"messageColor"
#define kMessageFontNameKey @"messageFontName"
#define kMessageFontSizeKey @"messageFontSize"
#define kTopStripeColorKey @"topStripeColor"
#define kButtonColorKey @"buttonColor"
#define kButtonTitleColorKey @"buttonTitleColor"
#define kButtonHighlightedColorKey @"buttonHighlightedColor"
#define kButtonTitleFontNameKey @"buttonTitleFontName"
#define kButtonTitleFontSizeKey @"buttonTitleFontSize"
#define kCancelButtonColorKey @"cancelButtonColor"
#define kCancelButtonHighlightedColorKey @"cancelButtonHighlightedColor"
#define kCancelButtonTitleColorKey @"cancelButtonTitleColor"
#define kCancelButtonTitleFontNameKey @"cancelButtonTitleFontName"
#define kCancelButtonTitleFontSizeKey @"cancelButtonTitleFontSize"

#pragma mark - Some Other Keys

#define kButtonTitleKey @"buttonTitle"
#define kButtonAttributesKey @"ButtonAttributes"
#define kButtonHandlerKey @"ButtonHandler"
#define kButtonKey @"Button"
#define kDefaultPlist @"ETHAlertView-Config"
#define kUserPlistKey @"ETHAlertViewFile"

#pragma mark - Default Property Values

#define kDefaultBackgroundColor [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define kDefaultTitleColor [UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1]
#define kDefaultTitleFont [UIFont fontWithName:@"AmericanTypewriter" size:18]
#define kDefaultMessageColor [UIColor colorWithRed:0.53 green:0.56 blue:0.55 alpha:1]
#define kDefaultMessageFont [UIFont fontWithName:@"AmericanTypewriter" size:15]
#define kDefaultTopStripeColor [UIColor colorWithRed:0.9 green:0.45 blue:0 alpha:1]
#define kDefaultButtonColor [UIColor grayColor]
#define kDefaultButtonTitleColor [UIColor whiteColor]
#define kDefaultButtonTitleFont [UIFont fontWithName:@"AmericanTypewriter" size:15]
#define kDefaultCancelButtonColor [UIColor colorWithRed:0.9 green:0.45 blue:0 alpha:1]
#define kDefaultCancelButtonTitleColor [UIColor whiteColor]
#define kDefaultCancelButtonTitleFont [UIFont fontWithName:@"AmericanTypewriter" size:15]
#define kDefaultButtonHighlightColor [UIColor colorWithWhite:0 alpha:0.5]

#pragma mark - ETHAlertView Private Properties

@interface ETHAlertView ()

@property (nonatomic, strong) NSMutableArray *normalButtons;
@property (nonatomic, strong) NSMutableArray *cancelButtons;
@property (nonatomic, strong) NSMutableArray *styledButtons;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIView *fadedView;
@property (nonatomic, assign) float currentSubviewYOffset;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) UIDeviceOrientation currentOrientation;
@property (nonatomic, assign) BOOL isPresented;
@property (nonatomic, assign) BOOL alertCreated;
@property (nonatomic, strong) UIWindow *window;

#pragma mark - Alert View Custom Properties

@property (nonatomic, strong) UIColor *alertBackgroundColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *messageColor;
@property (nonatomic, strong) UIFont *messageFont;
@property (nonatomic, strong) UIColor *topStripeColor;
@property (nonatomic, strong) UIColor *buttonColor;
@property (nonatomic, strong) UIColor *buttonTitleColor;
@property (nonatomic, strong) UIFont *buttonTitleFont;
@property (nonatomic, strong) UIColor *cancelButtonColor;
@property (nonatomic, strong) UIColor *cancelButtonTitleColor;
@property (nonatomic, strong) UIFont *cancelButtonTitleFont;
@property (nonatomic, strong) UIColor *buttonHighlightedColor;
@property (nonatomic, strong) UIColor *cancelButtonHighlightedColor;

@end

@implementation ETHAlertView

#pragma mark - Public Methods

- (id)initWithTitle:(NSString *)title message:(NSString *)message {
  
  return [self initWithTitle:title message:message settings:nil];
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           settings:(NSString *)plist {
  
  if((self = [super init])) {
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setFrame:[[UIScreen mainScreen] bounds]];
    
    [self setupFadedView];
    
    // save title and message
    self.title = title;
    self.message = message;
    self.isPresented = NO;
    self.alertCreated = NO;
    
    self.alertView = [[UIView alloc] init];
    [self addSubview:self.alertView];
    
    self.window = [[UIWindow alloc] initWithFrame:self.frame];
    [self.window setWindowLevel:UIWindowLevelAlert];
    
    [self configureDefaultAttributes];
    
    if(plist) {
      // if user explicitly provides a plist, override the properties from it
      NSString *path = [plist stringByDeletingPathExtension];
      NSString *defaultPath = [[NSBundle mainBundle] pathForResource:path
                                                              ofType:@"plist"];
      NSFileManager *fileManager = [NSFileManager defaultManager];
      NSDictionary *defaultDict = [[NSDictionary alloc]
                                   initWithContentsOfFile:defaultPath];
      if([fileManager fileExistsAtPath:defaultPath]) {
        [self configurePropertiesFromDict:defaultDict];
      }
    }
  }
  return self;
}

- (void)addButtonWithTitle:(NSString *)title
             actionHandler:(ETHAlertViewBlock)actionHandler {
  
  // create empty mutable arrays to hold button references
  if(!self.normalButtons) {
    self.normalButtons = [NSMutableArray array];
  }
  
  NSDictionary *normalButtonDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    title, kButtonTitleKey,
                                    [actionHandler copy], kButtonHandlerKey,
                                    nil];
  [self.normalButtons addObject:normalButtonDict];
}

- (void)addCancelButtonWithTitle:(NSString *)title
                   actionHandler:(ETHAlertViewBlock)actionHandler {
  
  // create empty mutable arrays to hold button references
  if(!self.cancelButtons) {
    self.cancelButtons = [NSMutableArray array];
  }
  
  NSDictionary *cancelButtonDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    title, kButtonTitleKey,
                                    [actionHandler copy], kButtonHandlerKey,
                                    nil];
  [self.cancelButtons addObject:cancelButtonDict];
}

- (void)show {
  
  if(!self.isPresented) {
    self.isPresented = YES;
    [self setupAlertViewWithTitle:self.title message:self.message];
    
    if(!self.alertCreated) {
      self.alertCreated = YES;
      // add buttons that are saved
      [self addButtons];
      
      // set frame depending on number of buttons
      [self setupAlertViewFrame];
    }
    
    if(self.rotationEnabled) {
      // Listen to orientation changes
      [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
      [[NSNotificationCenter defaultCenter]
       addObserver:self
       selector:@selector(deviceOrientationDidChange:)
       name:UIDeviceOrientationDidChangeNotification
       object:nil];
    }
    
    // add the alert on the key window
    [self.window setHidden:NO];
    [self.window addSubview:self];
    
    // animate the alert
    [self animateIn];
  }
  
}

#pragma mark - Custom Setup Subiew Methods

- (void)setupFadedView {
  self.fadedView = [[UIView alloc] initWithFrame:self.frame];
  [self.fadedView setContentMode:UIViewContentModeCenter];
  [self.fadedView setBackgroundColor:[UIColor blackColor]];
  [self.fadedView setAlpha:0];
  [self addSubview:self.fadedView];
}

- (void)setupAlertViewWithTitle:(NSString *)title message:(NSString *)message {
  
  [self.alertView setBackgroundColor:self.alertBackgroundColor];
  
  // initialize offset variable
  self.currentSubviewYOffset = 0;
  
  // create and add top stripe
  if(self.topSpriteEnabled) {
    [self setupTopStripe];
  }
  
  // move current offset
  if (title)
  {
    [self setupTitle:title];
  }
  
  if (message)
  {
    [self setupMessage:message];
  }
}

- (void)setupTopStripe {
  // add top space
  self.currentSubviewYOffset += 0;
  
  CGRect topStripeFrame = CGRectMake(0, 0, kAlertViewWidth, kTopStripeHeight);
  UIView *topStripe = [[UIView alloc] initWithFrame:topStripeFrame];
  [topStripe setBackgroundColor:self.topStripeColor];
  [self.alertView addSubview:topStripe];
  
  // add bottom space
  self.currentSubviewYOffset += kTopStripeHeight;
}

- (void)setupTitle:(NSString *)title {
  //add top space
  self.currentSubviewYOffset += kTitleTopSpace;
  
  UILabel *titleLabel = [self labelWithText:title
                                      color:self.titleColor
                                       font:self.titleFont];
  
  float titleLabelHeight = titleLabel.frame.size.height;
  
  // set frame origin
  float centerY = self.currentSubviewYOffset + titleLabelHeight/2;
  [titleLabel setCenter:CGPointMake(kAlertViewWidth/2, centerY)];
  
  [self.alertView addSubview:titleLabel];
  
  // add bottom space
  self.currentSubviewYOffset += titleLabelHeight;
}

- (void)setupMessage:(NSString *)message {
  //add top space
  self.currentSubviewYOffset += kMessageTopSpace;
  
  UILabel *messageLabel = [self labelWithText:message
                                        color:self.messageColor
                                         font:self.messageFont];
  
  float messageLabelHeight = messageLabel.frame.size.height;
  float messageLabelY = self.currentSubviewYOffset + messageLabelHeight/2;
  // set frame origin
  [messageLabel setCenter:CGPointMake(kAlertViewWidth/2, messageLabelY)];
  
  [self.alertView addSubview:messageLabel];
  
  // add bottom space
  self.currentSubviewYOffset += messageLabel.frame.size.height;
}

- (void)addButtons {
  [self createSyledButtons];
  self.currentSubviewYOffset += kButtonTopSpace;
  
  if(self.styledButtons.count == 2) {
    [self alingButtonsHorizontally];
  } else {
    [self alignButtonsVertically];
  }
}

// Create A common dictionary array containing all the buttons,normal and cancel
- (void)createSyledButtons {
  if(!self.styledButtons) {
    self.styledButtons = [NSMutableArray array];
  }
  
  for(NSDictionary *buttonDict in self.normalButtons) {
    NSString *title = [buttonDict objectForKey:kButtonTitleKey];
    UIButton *button = [self buttonWithTitle:title
                                       color:self.buttonColor
                            highlightedColor:self.buttonHighlightedColor
                                  titleColor:self.buttonTitleColor
                                   titleFont:self.buttonTitleFont];
    id actionHandler = [buttonDict objectForKey:kButtonHandlerKey];
    NSDictionary *styledButtonDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      button, kButtonKey,
                                      actionHandler, kButtonHandlerKey,
                                      nil];
    [self.styledButtons addObject:styledButtonDict];
  }
  
  for(NSDictionary *cancelButtonDict in self.cancelButtons) {
    NSString *title = [cancelButtonDict objectForKey:kButtonTitleKey];
    UIButton *button = [self buttonWithTitle:title
                                       color:self.cancelButtonColor
                            highlightedColor:self.cancelButtonHighlightedColor
                                  titleColor:self.cancelButtonTitleColor
                                   titleFont:self.cancelButtonTitleFont];
    id actionHandler = [cancelButtonDict objectForKey:kButtonHandlerKey];
    NSDictionary *styledButtonDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      button, kButtonKey,
                                      actionHandler, kButtonHandlerKey,
                                      nil];
    [self.styledButtons addObject:styledButtonDict];
  }
}

- (void)alingButtonsHorizontally {
  
  [self.styledButtons
   enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
     
     UIButton *button = [obj objectForKey:kButtonKey];
     // add button on alertview
     [button setTag:idx];
     [button setFrame:CGRectMake(kButtonXoffset*(idx+1) + kSmallButtonWidth*idx,
                                 self.currentSubviewYOffset,
                                 kSmallButtonWidth,
                                 kButtonHeight)];
     [self.alertView addSubview:button];
   }];
  
  self.currentSubviewYOffset += kButtonHeight;
  self.currentSubviewYOffset += kVerticalButtonGap;
}

- (void)alignButtonsVertically {
  
  [self.styledButtons
   enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
     
     UIButton *button = [obj objectForKey:kButtonKey];
     // add button on alertview
     [button setTag:idx];
     
     [button setFrame:CGRectMake(kButtonXoffset,
                                 self.currentSubviewYOffset,
                                 kLargeButtonWidth,
                                 kButtonHeight)];
     self.currentSubviewYOffset += kButtonHeight;
     self.currentSubviewYOffset += kVerticalButtonGap;
     
     [self.alertView addSubview:button];
   }];
}

#pragma mark - Custom View Element Methods

- (UILabel *)labelWithText:(NSString *)text
                     color:(UIColor *)color
                      font:(UIFont *)font {
  
  UILabel *label = [[UILabel alloc] init];
  [label setText:text];
  [label setFont:font];
  [label setTextColor:color];
  [label setNumberOfLines:0];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setTextAlignment:NSTextAlignmentCenter];
  
  CGSize labelSize = [text sizeWithFont:font
                      constrainedToSize:CGSizeMake(kMaxLabelWidth, kMaxLabelHeight)
                          lineBreakMode:NSLineBreakByWordWrapping];
  
  // set frame size
  CGRect labelFrame = label.frame;
  labelFrame.size = CGSizeMake(kMaxLabelWidth, labelSize.height);
  [label setFrame:labelFrame];
  
  return label;
}

- (UIButton *)buttonWithTitle:(NSString *)title
                        color:(UIColor *)color
             highlightedColor:(UIColor *)highlightedColor
                   titleColor:(UIColor *)titleColor
                    titleFont:(UIFont *)titleFont {
  
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:title forState:UIControlStateNormal];
  [button setBackgroundColor:color];
  [button setTitleColor:titleColor forState:UIControlStateNormal];
  [button.titleLabel setFont:titleFont];
  [button.titleLabel sizeToFit];
  [button addTarget:self
             action:@selector(dismiss:)
   forControlEvents:UIControlEventTouchUpInside];
  
  CGRect hrect = CGRectMake(0, 0, 1, 1);
  UIGraphicsBeginImageContext(hrect.size);
  CGContextRef hcontext = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(hcontext,
                                 [highlightedColor CGColor]);
  
  CGContextFillRect(hcontext, hrect);
  UIImage *himg = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  [button setBackgroundImage:himg forState:UIControlStateHighlighted];
  
  return button;
}

#pragma mark - Custom Frame Setup Methods

- (void)setupAlertViewFrame {
  // set alertview size
  CGRect alertViewFrame = self.alertView.frame;
  alertViewFrame.size = CGSizeMake(kAlertViewWidth, self.currentSubviewYOffset);
  [self.alertView setFrame:alertViewFrame];
  
  // set alertview origin
  [self.alertView setCenter:CGPointMake(CGRectGetMidX(self.frame),
                                        CGRectGetMidY(self.frame))];
}

#pragma mark - Custom Animation Methods

- (void)animateIn {
  
  [UIView animateWithDuration:kAnimationDuration animations:^{
    [self.fadedView setAlpha:kFadedViewAlpha];
  }];
  
  [self animateAlertView];
}

- (void)animateAlertView {
  
  CGAffineTransform small = CGAffineTransformMakeScale(0.8, 0.8);
  CGAffineTransform medium = CGAffineTransformMakeScale(0.95, 0.95);
  CGAffineTransform large = CGAffineTransformMakeScale(1.05, 1.05);
  
  self.alertView.transform = small;
  [UIView animateWithDuration: 0.2
                   animations: ^{
                     self.alertView.transform = large;
                   } completion: ^(BOOL finished){
                     [UIView animateWithDuration:1.0/10.0
                                      animations: ^{
                                        self.alertView.transform = medium;
                                      } completion: ^(BOOL finished){
                                        [UIView animateWithDuration:1.0/5
                                                         animations: ^{
                                                           self.alertView.transform =
                                                           CGAffineTransformIdentity;
                                                         }];
                                      }];
                   }];
}

- (void)animateOut {
  
  [UIView animateWithDuration:kAnimationDuration animations:^{
    [self setAlpha:0];
  } completion:^(BOOL finished) {
    self.isPresented = NO;
    [self removeFromSuperview];
    [self setAlpha:1];
  }];
}

#pragma mark - Custom Action Listener Methods

- (void)dismiss:(id)sender {
  
  NSDictionary *buttonDict = [self.styledButtons objectAtIndex:[sender tag]];
  ETHAlertViewBlock block = [buttonDict objectForKey:kButtonHandlerKey];
  if(block) {
    block(sender);
  }
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
  [self animateOut];
}

#pragma mark - Orientation Rotation Methods

- (void)deviceOrientationDidChange:(NSNotification *)notification {
  //Obtaining the current device orientation
  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  
  //Ignoring specific orientations
  if (orientation == UIDeviceOrientationFaceUp ||
      orientation == UIDeviceOrientationFaceDown ||
      orientation == UIDeviceOrientationUnknown ||
      orientation == UIDeviceOrientationPortraitUpsideDown ||
      self.currentOrientation == orientation) {
    return;
  }
  
  //Responding only to changes in landscape or portrait
  self.currentOrientation = orientation;
  
  switch (self.currentOrientation) {
    case UIDeviceOrientationPortrait: {
      [UIView animateWithDuration:0.3 animations:^{
        self.alertView.transform = CGAffineTransformMakeRotation(0);
      }];
    }
      break;
    case UIDeviceOrientationLandscapeLeft: {
      [UIView animateWithDuration:0.3 animations:^{
        self.alertView.transform = CGAffineTransformMakeRotation(M_PI_2);
      }];
    }
      break;
    case UIDeviceOrientationLandscapeRight: {
      [UIView animateWithDuration:0.3 animations:^{
        self.alertView.transform = CGAffineTransformMakeRotation(-M_PI_2);
      }];
    }
      break;
    default:
      break;
  }
}

#pragma mark - Other Custom Methods

- (void)configureDefaultAttributes {
  [self setDefaultAlertViewAttributes];
  [self setDefaultButtonAttributes];
  [self setDefaultCancelButtonAttributes];
  
  // if default plist exists, override properties from it
  [self overridePropertiesFromPlist:kDefaultPlist];
  
  // if user plist exists, override values from it
  if([[[NSBundle mainBundle] infoDictionary] objectForKey:kUserPlistKey]) {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *plist = [infoDict objectForKey:kUserPlistKey];
    [self overridePropertiesFromPlist:plist];
  }
}

- (void)overridePropertiesFromPlist:(NSString *)plist {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  
  NSString *resourceName = [plist stringByDeletingPathExtension];
  NSString *path = [[NSBundle mainBundle] pathForResource:resourceName
                                                   ofType:@"plist"];
  NSDictionary *plistDict = [[NSDictionary alloc] initWithContentsOfFile:path];
  if([fileManager fileExistsAtPath:path]) {
    [self configurePropertiesFromDict:plistDict];
  }
  
}

- (void)setDefaultAlertViewAttributes {
  self.alertBackgroundColor = kDefaultBackgroundColor;
  self.titleColor = kDefaultTitleColor;
  self.titleFont = kDefaultTitleFont;
  self.messageColor = kDefaultMessageColor;
  self.messageFont = kDefaultMessageFont;
  self.topStripeColor = kDefaultTopStripeColor;
  
  self.topSpriteEnabled = YES;
  self.rotationEnabled = YES;
}

- (void)setDefaultButtonAttributes {
  self.buttonColor = kDefaultButtonColor;
  self.buttonTitleColor = kDefaultButtonTitleColor;
  self.buttonTitleFont = kDefaultButtonTitleFont;
  self.buttonHighlightedColor = kDefaultButtonHighlightColor;
}

- (void)setDefaultCancelButtonAttributes {
  self.cancelButtonColor = kDefaultCancelButtonColor;
  self.cancelButtonTitleColor = kDefaultCancelButtonTitleColor;
  self.cancelButtonTitleFont =kDefaultCancelButtonTitleFont;
  self.cancelButtonHighlightedColor = kDefaultButtonHighlightColor;
}

- (void)configurePropertiesFromDict:(NSDictionary *)plistDict {
  
  if([self isValidColorKey:kBackgroundColorKey forPlist:plistDict]) {
    NSArray *titleColor = [plistDict objectForKey:kBackgroundColorKey];
    [self setAlertBackgroundColor:
     [UIColor colorWithRed:[[titleColor objectAtIndex:0] floatValue]
                     green:[[titleColor objectAtIndex:1] floatValue]
                      blue:[[titleColor objectAtIndex:2] floatValue]
                     alpha:[[titleColor objectAtIndex:3] floatValue]]];
  }
  
  if([self isValidColorKey:kTitleColorKey forPlist:plistDict]) {
    NSArray *titleColor = [plistDict objectForKey:kTitleColorKey];
    [self setTitleColor:
     [UIColor colorWithRed:[[titleColor objectAtIndex:0] floatValue]
                     green:[[titleColor objectAtIndex:1] floatValue]
                      blue:[[titleColor objectAtIndex:2] floatValue]
                     alpha:[[titleColor objectAtIndex:3] floatValue]]];
  }
  
  if([plistDict objectForKey:kTitleFontNameKey]) {
    [self setTitleFont:
     [UIFont fontWithName:[plistDict objectForKey:kTitleFontNameKey]
                     size:self.titleFont.pointSize]];
  }
  
  if([plistDict objectForKey:kTitleFontSizeKey]) {
    [self setTitleFont:
     [UIFont fontWithName:self.titleFont.fontName
                     size:[[plistDict objectForKey:kTitleFontSizeKey] floatValue]]];
  }
  
  if([self isValidColorKey:kMessageColorKey forPlist:plistDict]) {
    NSArray *messageColor = [plistDict objectForKey:kMessageColorKey];
    [self setMessageColor:
     [UIColor colorWithRed:[[messageColor objectAtIndex:0] floatValue]
                     green:[[messageColor objectAtIndex:1] floatValue]
                      blue:[[messageColor objectAtIndex:2] floatValue]
                     alpha:[[messageColor objectAtIndex:3] floatValue]]];
  }
  
  if([plistDict objectForKey:kMessageFontNameKey]) {
    [self setMessageFont:
     [UIFont fontWithName:[plistDict objectForKey:kMessageFontNameKey]
                     size:self.messageFont.pointSize]];
  }
  
  if([plistDict objectForKey:kMessageFontSizeKey]) {
    [self setMessageFont:
     [UIFont fontWithName:self.messageFont.fontName
                     size:[[plistDict objectForKey:kMessageFontSizeKey] floatValue]]];
  }
  
  if([self isValidColorKey:kTopStripeColorKey forPlist:plistDict]) {
    NSArray *topStripeColor = [plistDict objectForKey:kTopStripeColorKey];
    [self setTopStripeColor:
     [UIColor colorWithRed:[[topStripeColor objectAtIndex:0] floatValue]
                     green:[[topStripeColor objectAtIndex:1] floatValue]
                      blue:[[topStripeColor objectAtIndex:2] floatValue]
                     alpha:[[topStripeColor objectAtIndex:3] floatValue]]];
  }
  
  if([self isValidColorKey:kButtonColorKey forPlist:plistDict]) {
    NSArray *buttonColor = [plistDict objectForKey:kButtonColorKey];
    [self setButtonColor:
     [UIColor colorWithRed:[[buttonColor objectAtIndex:0] floatValue]
                     green:[[buttonColor objectAtIndex:1] floatValue]
                      blue:[[buttonColor objectAtIndex:2] floatValue]
                     alpha:[[buttonColor objectAtIndex:3] floatValue]]];
  }
  
  if([self isValidColorKey:kButtonHighlightedColorKey forPlist:plistDict]) {
    NSArray *buttonTitleColor = [plistDict objectForKey:kButtonHighlightedColorKey];
    [self setButtonHighlightedColor:
     [UIColor colorWithRed:[[buttonTitleColor objectAtIndex:0] floatValue]
                     green:[[buttonTitleColor objectAtIndex:1] floatValue]
                      blue:[[buttonTitleColor objectAtIndex:2] floatValue]
                     alpha:[[buttonTitleColor objectAtIndex:3] floatValue]]];
  }
  
  if([self isValidColorKey:kButtonTitleColorKey forPlist:plistDict]) {
    NSArray *buttonTitleColor = [plistDict objectForKey:kButtonTitleColorKey];
    [self setButtonTitleColor:
     [UIColor colorWithRed:[[buttonTitleColor objectAtIndex:0] floatValue]
                     green:[[buttonTitleColor objectAtIndex:1] floatValue]
                      blue:[[buttonTitleColor objectAtIndex:2] floatValue]
                     alpha:[[buttonTitleColor objectAtIndex:3] floatValue]]];
  }
  
  if([plistDict objectForKey:kButtonTitleFontNameKey]) {
    [self setButtonTitleFont:
     [UIFont fontWithName:[plistDict objectForKey:kButtonTitleFontNameKey]
                     size:self.buttonTitleFont.pointSize]];
  }
  
  if([plistDict objectForKey:kButtonTitleFontSizeKey]) {
    [self setButtonTitleFont:
     [UIFont fontWithName:self.buttonTitleFont.fontName
                     size:[[plistDict objectForKey:kButtonTitleFontSizeKey] floatValue]]];
  }
  
  if([self isValidColorKey:kCancelButtonColorKey forPlist:plistDict]) {
    NSArray *buttonColor = [plistDict objectForKey:kCancelButtonColorKey];
    [self setCancelButtonColor:
     [UIColor colorWithRed:[[buttonColor objectAtIndex:0] floatValue]
                     green:[[buttonColor objectAtIndex:1] floatValue]
                      blue:[[buttonColor objectAtIndex:2] floatValue]
                     alpha:[[buttonColor objectAtIndex:3] floatValue]]];
  }
  
  if([self isValidColorKey:kCancelButtonTitleColorKey forPlist:plistDict]) {
    NSArray *buttonTitleColor = [plistDict objectForKey:kCancelButtonTitleColorKey];
    [self setCancelButtonTitleColor:
     [UIColor colorWithRed:[[buttonTitleColor objectAtIndex:0] floatValue]
                     green:[[buttonTitleColor objectAtIndex:1] floatValue]
                      blue:[[buttonTitleColor objectAtIndex:2] floatValue]
                     alpha:[[buttonTitleColor objectAtIndex:3] floatValue]]];
  }
  
  if([self isValidColorKey:kCancelButtonHighlightedColorKey forPlist:plistDict]) {
    NSArray *buttonTitleColor = [plistDict objectForKey:kCancelButtonHighlightedColorKey];
    [self setCancelButtonHighlightedColor:
     [UIColor colorWithRed:[[buttonTitleColor objectAtIndex:0] floatValue]
                     green:[[buttonTitleColor objectAtIndex:1] floatValue]
                      blue:[[buttonTitleColor objectAtIndex:2] floatValue]
                     alpha:[[buttonTitleColor objectAtIndex:3] floatValue]]];
  }
  
  if([plistDict objectForKey:kCancelButtonTitleFontNameKey]) {
    [self setCancelButtonTitleFont:
     [UIFont fontWithName:[plistDict objectForKey:kCancelButtonTitleFontNameKey]
                     size:self.cancelButtonTitleFont.pointSize]];
  }
  
  if([plistDict objectForKey:kCancelButtonTitleFontSizeKey]) {
    [self setCancelButtonTitleFont:
     [UIFont fontWithName:self.cancelButtonTitleFont.fontName
                     size:[[plistDict objectForKey:kCancelButtonTitleFontSizeKey] floatValue]]];
  }
  
  
}

- (BOOL)isValidColorKey:(NSString *)colorKey forPlist:(NSDictionary *)plistDict {
  return (([plistDict objectForKey:colorKey]) &&
          ([[plistDict objectForKey:colorKey] isKindOfClass:[NSArray class]]) &&
          ([[plistDict objectForKey:colorKey] count] == 4));
}

@end