//
//  ViewController.m
//  Example
//
//  Created by John MAClovich on 21/08/2019.
//  Copyright © 2019 Inception. All rights reserved.
//

#import "ViewController.h"
#import <UnityLauncher/Launcher.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction) openUnity {
    NSLog(@"gggg");
    [Launcher startUnity: self];
}

@end
