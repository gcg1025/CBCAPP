//
//  AlertV.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/8.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "AlertV.h"

@interface AlertV ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation AlertV

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"如需查看请联系15333612035(微信同此号)购买。"];
    [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:[UIColor darkGrayColor]} range:NSMakeRange(0, str.length)];
    [str addAttributes:@{NSForegroundColorAttributeName:kHexColor(@"FF9018", 1)} range:[@"如需查看请联系15333612035(微信同此号)购买。" rangeOfString:@"15333612035"]];
    self.titleLab.attributedText = str;
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
}

- (IBAction)bayAct:(id)sender {
    [self hideView];
    [[Tool shareInstance].currentViewController toOrderAct];
}

@end
