//
//  NewsDetailsFontV.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/25.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "NewsDetailsFontV.h"

@interface NewsDetailsFontV ()

@property (weak, nonatomic) IBOutlet UIView *backgroundV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundVBotCon;

@end

@implementation NewsDetailsFontV

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundVBotCon.constant = -150;
    self.backgroundV.layer.borderWidth = 1;
    self.backgroundV.layer.borderColor = kHexColor(kNavBackgroundColorHex, 1).CGColor;
    [self layoutIfNeeded];
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    for (NSInteger i = 0; i < 4; i ++) {
        UILabel *lab = [self.backgroundV viewWithTag:10000 + i];
        if (i == index) {
            lab.textColor = kHexColor(@"FFFFFF", 1);
            lab.backgroundColor = kHexColor(kNavBackgroundColorHex, 1);
        } else {
            lab.textColor = kHexColor(@"000000", 1);
            lab.backgroundColor = kHexColor(@"FFFFFF", 1);
        }
    }
}

- (IBAction)selectAct:(UIButton *)sender {
    for (NSInteger i = 0; i < 4; i ++) {
        UILabel *lab = [self.backgroundV viewWithTag:10000 + i];
        if (i == sender.tag - 30000) {
            lab.textColor = kHexColor(@"FFFFFF", 1);
            lab.backgroundColor = kHexColor(kNavBackgroundColorHex, 1);
        } else {
            lab.textColor = kHexColor(@"000000", 1);
            lab.backgroundColor = kHexColor(@"FFFFFF", 1);
        }
    }
    if (self.selectBlock) {
        self.selectBlock(sender.tag - 30000);
    }
}

- (void)showView {
    self.alpha = 1;
    self.backgroundVBotCon.constant = 0;
    kWeakSelf
    [UIView animateWithDuration:0.4 animations:^{
        [weakSelf layoutIfNeeded];
    }];
}

- (void)hideView {
    self.backgroundVBotCon.constant = -150;
    kWeakSelf
    [UIView animateWithDuration:0.4 animations:^{
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        weakSelf.alpha = 0;
    }];
}

- (IBAction)hideAct:(id)sender {
    [self hideView];
}

@end
