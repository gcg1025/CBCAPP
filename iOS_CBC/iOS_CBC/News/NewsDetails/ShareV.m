//
//  ShareV.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/2.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "ShareV.h"

@interface ShareV ()

@property (weak, nonatomic) IBOutlet UIView *bgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heiCon;

@end

@implementation ShareV

- (void)awakeFromNib {
    [super awakeFromNib];
    self.heiCon.constant = 190 + kBottomH;
    self.topCon.constant = 0;
    [self layoutIfNeeded];
}

- (IBAction)closeAct:(id)sender {
    [self hideView];
}

- (void)showView {
    self.alpha = 1;
    self.topCon.constant = -(190 + kBottomH);
    kWeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}

- (void)hideView {
    self.topCon.constant = 0;
    kWeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        weakSelf.alpha = 0;
    }];
}

- (IBAction)shareAct:(UIButton *)sender {
    if (self.shareBlock) {
        self.shareBlock(sender.tag - 30000);
    }
    [self hideView];
}

@end
