//
//  AboutVC.m
//  iOS_CBC
//
//  Created by SDB_Mac on 2020/1/3.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setViews {
    [self setNavigationBarWithTitle:@"关于我们" hasBackBtn:true];
    NSString *version= [UIDevice currentDevice].systemVersion;
    if (version.doubleValue < 11) {
        self.topCon.constant = 64;
        [self.view layoutIfNeeded];
    }
}

@end
