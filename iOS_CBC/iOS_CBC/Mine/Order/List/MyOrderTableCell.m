//
//  MyOrderTableCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/24.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "MyOrderTableCell.h"

@interface MyOrderTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *payLab;
@property (weak, nonatomic) IBOutlet UILabel *startLab;
@property (weak, nonatomic) IBOutlet UILabel *endTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *endLab;
@property (weak, nonatomic) IBOutlet UILabel *endTipLab;
@property (weak, nonatomic) IBOutlet UIButton *btn;


@end

@implementation MyOrderTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(OrderInfoM *)model {
    _model = model;
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    self.titleLab.text = model.title;
    self.stateLab.text = model.state == 0 ? @"待支付" : @"已支付";
    self.orderNumLab.text = model.orderNumber;
    self.timeLab.text = [timeFormatter stringFromDate:[timeFormatter dateFromString:model.systemDate]];
    self.payLab.text = [NSString stringWithFormat:@"¥%@", model.payMoney];
    NSArray<NSString *> *dateAry = [model.startdate componentsSeparatedByString:@" "];
    self.startLab.text = dateAry.count ? [dayFormatter stringFromDate:[dayFormatter dateFromString:dateAry[0]]] : model.startdate;
    dateAry = [model.vipdate componentsSeparatedByString:@" "];
    self.endLab.text = dateAry.count ? [dayFormatter stringFromDate:[dayFormatter dateFromString:dateAry[0]]] : model.vipdate;
    self.stateLab.textColor = kHexColor(kTintColorHex, 1);
    self.endTipLab.alpha = 0;
    self.btn.alpha = 0;
    if (model.state == 1) {
        self.payLab.textColor = [UIColor blackColor];
        self.endLab.textColor = kHexColor(kTintColorHex, 1);
        self.endTitleLab.textColor = kHexColor(kTintColorHex, 1);
        self.endTipLab.textColor = kHexColor(kTintColorHex, 1);
        if (dateAry.count) {
            NSTimeInterval endT = [dayFormatter dateFromString:dateAry[0]].timeIntervalSince1970;
            NSTimeInterval currentT = [dayFormatter dateFromString:[dayFormatter stringFromDate:[NSDate date]]].timeIntervalSince1970;
            if (endT <= currentT + 30 * 24 * 3600) {
                self.btn.alpha = 1;
                [self.btn setTitle:@"立即续费" forState:UIControlStateNormal];
                self.btn.backgroundColor = kHexColor(kTintColorHex, 1);
                self.endTipLab.alpha = 1;
                self.stateLab.textColor = [UIColor darkGrayColor];
                if (endT < currentT) {
                    self.endTipLab.text = [NSString stringWithFormat:@"已经到期%@天!", @((currentT - endT) / 24 / 3600)];
                    self.endLab.textColor = kHexColor(@"EE273C", 1);
                    self.endTitleLab.textColor = kHexColor(@"EE273C", 1);
                    self.endTipLab.textColor = kHexColor(@"EE273C", 1);
                } else {
                    self.endTipLab.text = [NSString stringWithFormat:@"距离到期%@天!", @((endT - currentT) / 24 / 3600 + 1)];
                }
            }
        }
    } else {
        self.payLab.textColor = kHexColor(@"EE273C", 1);
        self.endLab.textColor = [UIColor blackColor];
        self.endTitleLab.textColor = [UIColor darkGrayColor];
        self.btn.alpha = 1;
        [self.btn setTitle:@"立即支付" forState:UIControlStateNormal];
        self.btn.backgroundColor = kHexColor(kNavBackgroundColorHex, 1);
    }
}

- (IBAction)selectAct:(id)sender {
    if (self.selectBlock) {
        self.selectBlock(self.model);
    }
}

@end
