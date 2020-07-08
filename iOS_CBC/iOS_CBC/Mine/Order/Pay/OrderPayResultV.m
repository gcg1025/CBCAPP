//
//  OrderPayResultV.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/25.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "OrderPayResultV.h"

@implementation OrderPayResultV

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
}

- (void)hideView {
    self.alpha = 0;
}

- (void)showView {
    kWeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 1;
    }];
}

- (IBAction)closeAct:(id)sender {
    [self hideView];
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end
