//
//  main.m
//  Example
//
//  Created by John MAClovich on 21/08/2019.
//  Copyright © 2019 Inception. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <UnityLauncher/Launcher.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [Launcher unityInit:argc argv:(argv)];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
