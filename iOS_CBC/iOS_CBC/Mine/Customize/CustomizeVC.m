//
//  CustomizeVC.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/26.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "CustomizeVC.h"

@interface CustomizeVC ()

@property (weak, nonatomic) IBOutlet UIView *backgroundV;

@end

@implementation CustomizeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setViews {
    [self setNavigationBarWithTitle:@"我的定制" hasBackBtn:true];
    NoDataV *v = [[[NSBundle mainBundle] loadNibNamed:@"NoDataV" owner:nil options:NULL] lastObject];
    v.viewType = NoDataViewTypeCustomize;
    v.frame = self.backgroundV.bounds;
    [self.backgroundV addSubview:v];
}

@end
