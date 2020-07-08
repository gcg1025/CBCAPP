//
//  AlertUpdateV.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/21.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "AlertUpdateV.h"

@interface AlertUpdateV ()

@property (weak, nonatomic) IBOutlet UIView *versionBorderV;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *versionLab;


@end

@implementation AlertUpdateV

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.versionBorderV.layer.borderWidth = 0.5;
    self.versionBorderV.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)showView {
    self.contentLab.text = kValueForKey(kVersionContentKey);
    self.versionLab.text = [NSString stringWithFormat:@"V %@", kValueForKey(kVersionStoreKey)];
    [self layoutIfNeeded];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hideView {
    [self removeFromSuperview];
}

- (IBAction)updateAct:(id)sender {
    [self hideView];
    if (self.updateBlock) {
        self.updateBlock();
    }
}


@end
