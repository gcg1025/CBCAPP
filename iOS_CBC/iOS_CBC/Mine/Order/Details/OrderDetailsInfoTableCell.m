//
//  OrderDetailsInfoTableCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/24.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "OrderDetailsInfoTableCell.h"

@interface OrderDetailsInfoTableCell ()


@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *productLab;
@property (weak, nonatomic) IBOutlet UILabel *durationLab;
@property (weak, nonatomic) IBOutlet UILabel *startLab;
@property (weak, nonatomic) IBOutlet UILabel *endLab;
@property (weak, nonatomic) IBOutlet UILabel *payLab;
@property (weak, nonatomic) IBOutlet UILabel *endTipLab;

@end

@implementation OrderDetailsInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(OrderInfoM *)model {
    if (!model) {
        return;
    }
    _model = model;
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDateFormatter *dayFormatter1 = [[NSDateFormatter alloc] init];
    [dayFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDateFormatter *timeFormatter1 = [[NSDateFormatter alloc] init];
    [timeFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.orderNumLab.text = model.orderNumber;
    self.timeLab.text = [timeFormatter1 stringFromDate:[timeFormatter dateFromString:model.privacyModel.systemDate]];
    self.productLab.text = model.privacyModel.productname;
    self.durationLab.text = [NSString stringWithFormat:@"%@年", model.privacyModel.duration];
    NSArray<NSString *> *dateAry = [model.privacyModel.startdate componentsSeparatedByString:@" "];
    self.startLab.text = dateAry.count ? [dayFormatter1 stringFromDate:[dayFormatter dateFromString:dateAry[0]]] : model.privacyModel.startdate;
    dateAry = [model.privacyModel.enddate componentsSeparatedByString:@" "];
    self.endLab.text = dateAry.count ? [dayFormatter1 stringFromDate:[dayFormatter dateFromString:dateAry[0]]] : model.privacyModel.enddate;
    self.endTipLab.alpha = 0;
    if (model.privacyModel.state.integerValue == 1) {
        if (dateAry.count) {
            NSTimeInterval endT = [dayFormatter dateFromString:dateAry[0]].timeIntervalSince1970;
            NSTimeInterval currentT = [dayFormatter dateFromString:[dayFormatter stringFromDate:[NSDate date]]].timeIntervalSince1970;
            if (endT < currentT) {
                self.endTipLab.alpha = 1;
                self.endTipLab.text = @"（已到期）";
            }
        }
    }
    self.payLab.text = @[@"————", @"支付宝", @"微信", ][model.privacyModel.payType.integerValue];
}

@end
