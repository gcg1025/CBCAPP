//
//  OrderPayResultTableCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/25.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "OrderPayResultTableCell.h"

@interface OrderPayResultTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@end

@implementation OrderPayResultTableCell

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
    self.titleLab.text = [NSString stringWithFormat:@"%@(%@年)", model.oriTitle, [Tool transYear:model.duration]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.startTimeLab.text = [NSString stringWithFormat:@"开始日期：%@", [dateFormatter stringFromDate:[NSDate date]]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:model.duration.integerValue];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.endTimeLab.text = [NSString stringWithFormat:@"到期日期：%@", [dateFormatter stringFromDate:[calendar dateByAddingComponents:components toDate:[NSDate date] options:0]]];
    self.contentLab.text = [NSString stringWithFormat:@"具体权限：%@", model.jieshao];
    self.priceLab.text = [NSString stringWithFormat:@"%@", model.payMoney];
}

- (IBAction)backAct:(id)sender {
    if (self.backBlock) {
        self.backBlock();
    }
}


@end
