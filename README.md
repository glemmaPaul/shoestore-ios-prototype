Template-ios
============

You can start every fueled project via this template. 
You just need to rename the project. 

This project template contains : 
  - All the configurations (build, Snapshot, Staging, Release)
  - You need to change the archive post-action script for each Scheme and replace <HOCKEY_TOKEN_ID> with the token id from hockey app relative to the current scheme and your project. And replace <REPO_NAME> with the name of the github repo of your new project. 
  - Please respect the architecture of the folders. You can add many groups inside these folders if you need to. 
  - You have at your disposal CocoaLumberjack, which is a really cool logger and we will use that logger for every new project from now on. 
  - There is a Constants.h file which should be used for all the global constants. 

