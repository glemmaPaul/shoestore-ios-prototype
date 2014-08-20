Ethanol
=======

Base Project for common libraries in iOS

Using Ethanol
-------------

There are two ways to use Ethanol :  
- Add it to your project using Cocoapods  

	pod 'Ethanol'
	
  And then run "pod install"

- Use the Ethanol.Framework product along with the Ethanol.bundle, and drag both of there file into your project.

Then to use the libraries, for instance to use the ETHAlertView, just import the class using :
    
	#import <ETHAlertView.h>
	
Or you can import the master header using:

	#import <Ethanol.h>


Updating pods
----------------------------
To update the workspace's Pods, you have to run 'pod update' in the folder that contains the Podfile.
After the update is completed, in order to run Ethanol Example, it is needed to its target's "Build Phases", and remove the libPod.a from the "Link Binary with Libraries" phase.  
Since Pods' resources aren't bundled (As of writing this readme) but directly copied into the target Project, Pods' resources aren't copied from "Ethanol" project to "Ethanol Example". The work around used here is to link the Pods with "Ethanol Example", so that it have the relevant resources, but since "Ethanol Example" also depends on "Ethanol" which already contains the Pods library, not doing those steps will result in a "duplicate symbol" error at link time.


