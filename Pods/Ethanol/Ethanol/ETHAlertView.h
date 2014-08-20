//
//  ETHAlertView.h
//  Ethanol
//
//  Created by Cameron Mulhern on 1/31/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ETHAlertViewBlock)();

/** A custom alert view class which can be instantiated like a
 normal UIAlertView. User can add a title, message and upto 4 buttons to the
 alertView. The buttons use actionhandlers to handle actions.
 User can set custom alert view properties using plists.
 To use a plist, create a plist in the same format as the
 ETHAlertView-Config.plist file, and create a key in the app-info.plist file
 called "ETHAlertViewFile" and its value equal to the name of the plist created.
 */
@interface ETHAlertView : UIView

/** This method instantiates and returns a new custom alert
 @param string Title of the alert
 @param string Message of the alert
 @return a new ETHAlertView instance
 */
- (id)initWithTitle:(NSString *)title message:(NSString *)message;
/** This method instantiates and returns a new custom alert with settings
 specified in the plist passed
 @param string Title of the alert
 @param string Message of the alert
 @param string Name of the plist that has the custom alert view values
 @return a new ETHAlertView instance
 */
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           settings:(NSString *)plist;
/** This method adds a button to the alert view
 @param string Title of the button
 @param string Action handler block of the button
 @return void
 */
- (void)addButtonWithTitle:(NSString *)title
             actionHandler:(ETHAlertViewBlock)actionHandler;
/** This method adds a cancel button to the alert view
 @param string Title of the button
 @param string Action handler block of the button
 @return void
 */
- (void)addCancelButtonWithTitle:(NSString *)title
                   actionHandler:(ETHAlertViewBlock)actionHandler;
/** This method displays the alert using either default or user-specified
 custom properties
 @param none
 @return void
 */
- (void)show;

@property (nonatomic, assign) BOOL topSpriteEnabled;
@property (nonatomic, assign) BOOL rotationEnabled;

@end
