//
//  Launcher.h
//  UnityLauncher
//
//  Created by John MAClovich on 02/04/2019.
//  Copyright © 2019 Inception. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Launcher : NSObject

+ (void) unityInit:(int) argc argv:(char**) argv;
+ (UIView *)unityView;
+ (void) startUnityWithArgs: (UIViewController*) viewController args:(NSString*) args;
+ (void) startUnity:(UIViewController*) view;
+ (char*) someFunction:(char*) data;
+ (void) stopUnity;
+ (void) unityStarted: (char*) object funcName:(char*) funcName;
+ (void) onUnityExit;
+ (const char*) getArguments;
+ (char*) makeStringCopy: (const char*) string;

@end
