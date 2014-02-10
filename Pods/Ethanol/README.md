Ethanol
=======

Base Project for common libraries in iOS

Using Ethanol
-------------

To use the Ethanol libraries in your project, after cloning the project, navigate to the root project folder (ethanol-ios). Then under the folder "Products", there will be an ETH.framework folder. Just drag this framework into your project. 

Then to use the libraries, for instance to use the ETHAlertView, just import the class using :
    
	#import <ETH/ETHAlertView.h>

Generating Ethanol Framework
----------------------------

To generate the framework (ETH.framework)

1. Add your .h (headers) files to the ETH Target -> Build Phases -> Copy Headers
2. Add your .m (implementation) files to ETH Target -> Build Phases -> Compile Sources
3. Add images or any other resources to the ETH Target -> Build Phases -> Copy Bundle Resources
4. Finally, build the EthanolAggregateTarget.

This will generate ETH.framework in the project root -> Products folder.


----------------------------

ETHUpdateChecker is used to check appstore updates

### ETHUpdateChecker Usage Instructions

1. In your `AppDelegate`, set the `appID` for your app: `[[ETHUpdateChecker sharedInstance] setAppID:@"<app_id>"]`.

2. In your `AppDelegate`, set the `alertType` for your app: `[[ETHUpdateChecker sharedInstance] setAlertType:<alert_type>]`.

3. In your `AppDelegate`, add **only one** of the `[[ETHUpdateChecker sharedInstance] checkVersion]` methods.

**NOTE: Call only one of the ETHUpdateChecker methods **
	

 obj-c
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  /*
   ETHUpdateChecker settings

   // Set the App ID for your app
   [[ETHUpdateChecker sharedInstance] setAppID:@"<app_id>"];

   // (Optional) Set the Alert Type for your app By default, the Singleton is initialized to ETUpdateCherkerAlertTypeOption
   [[ETHUpdateChecker sharedInstance] setAlertType:<alert_type>];

   // Perform check for new version of your app
   [[ETHUpdateChecker sharedInstance] checkVersion];

   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	/*
	 Perform daily check for new version of your app
	 Useful if user returns to you app from background after extended period of time
 	 Place in applicationDidBecomeActive:
 	 
 	 Also, performs version check on first launch.
   */
	[[ETHUpdateChecker sharedInstance] checkVersionDaily];
  
	/*
	 Perform weekly check for new version of your app
	 Useful if user returns to you app from background after extended period of time
	 Place in applicationDidBecomeActive:
	 
	 Also, performs version check on first launch.
	 */
	[[ETHUpdateChecker sharedInstance] checkVersionWeekly];
  }


