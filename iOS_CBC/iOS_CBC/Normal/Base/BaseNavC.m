//
//  BaseNavC.m
//  SDB_Optimize
//
//  Created by SDB_Mac on 2020/1/7.
//  Copyright © 2020 Regent. All rights reserved.
//

#import "BaseNavC.h"

@interface BaseNavC ()

@end

@implementation BaseNavC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.hidden = true;
}

- (BOOL)shouldAutorotate {
    return self.shouldAutoRatate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.interfaceOrientationMask;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.interfaceOrientation;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return false;
}

@end
