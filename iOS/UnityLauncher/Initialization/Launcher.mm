//
//  Launcher.m
//  UnityLauncher
//
//  Created by John MAClovich on 02/04/2019.
//  Copyright © 2019 Inception. All rights reserved.
//

#import "Launcher.h"
#import "UnityAppController.h"
#import "UnityInitialization.h"

@interface Launcher ()

@property (nonatomic, assign) bool isRunning;
@property (nonatomic, strong) UnityAppController *unityAppController;
@property (nonatomic, weak) UIViewController *unityViewController;

@end


@implementation Launcher

static NSString* unityArgs;
static NSString* unityObject;
static NSString* unityFunc;


- (instancetype)init {
    if (self = [super init]) {
        self.unityAppController = [UnityAppController new];
        [self.unityAppController application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:nil];
    }
    
    return self;
}

+ (void)unityInit:(int) argc argv:(char**) argv {
    NSLog(@"Unity Init!");
    UNITY_INIT(argc, argv);
}

+ (Launcher *)sharedInstance {
    static Launcher *instance = nil;
    
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken , ^{
        instance = [Launcher new];
    });
    
    return instance;
}

+ (void)startUnityWithArgs: (UIViewController*) viewController args:(NSString*) args{
    unityArgs = args;
    [Launcher startUnity:viewController];
    if (unityObject != nil){
        const char* cObjName = [unityObject UTF8String];
        const char* cFuncName = [unityFunc UTF8String];
        const char* cArgs = [args UTF8String];
        
        UnitySendMessage(cObjName, cFuncName, cArgs);
    }
}

+ (void)startUnity:(UIViewController*) viewController {
    
    if (![self sharedInstance].isRunning)
    {
        [self sharedInstance].isRunning = true;
        [[self sharedInstance].unityAppController applicationDidBecomeActive:UIApplication.sharedApplication];
        [self sharedInstance].unityAppController.window.hidden = NO;
    }
}

+ (char*)someFunction:(char*) data {
    NSString* str = @"This is from Launcher.mm";
    const char* cStr = [str UTF8String];
    return [Launcher makeStringCopy: cStr];
}

+ (void)stopUnity {
    if ([self sharedInstance].isRunning)
    {
        NSLog(@"stopUnity");
        [self sharedInstance].unityAppController.window.hidden = YES;
        [[self sharedInstance].unityAppController applicationWillResignActive:UIApplication.sharedApplication];
        [self sharedInstance].isRunning = false;
    }
}

+ (UIView *)unityView {
    NSLog(@"returning GLView");
    return UnityGetGLView();
}

+ (void)unityStarted: (char*) object funcName:(char*) funcName{
    unityObject = [NSString stringWithUTF8String:object];
    unityFunc = [NSString stringWithUTF8String:funcName];
}

+ (void)onUnityExit{
    [Launcher stopUnity];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Unity_Exit" object:nil];
}

+ (const char*)getArguments{
    const char *arg = [unityArgs UTF8String];
    return [Launcher makeStringCopy: arg];
}

+ (char*)makeStringCopy: (const char*) string {
    if (string == NULL) return NULL;
    char* res = (char*)malloc(strlen(string) + 1);
    strcpy(res, string);
    return res;
}

- (void)didFinishLaunching:(NSNotification *)notification
{
    NSDictionary *launchOptions = [notification userInfo];
    [self.unityAppController application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:launchOptions];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.unityAppController name:UIApplicationDidBecomeActiveNotification object:nil];
}

@end
