//
//  SupplyPurchaseTableCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/26.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "SupplyPurchaseTableCell.h"

@interface SupplyPurchaseTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation SupplyPurchaseTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(DistributionM *)model {
    self.titleLab.text = model.infotitle;
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDateFormatter *dayFormatterL = [[NSDateFormatter alloc] init];
    [dayFormatterL setDateFormat:@"MM月dd日"];
    NSArray *dateAry = [model.sysdate componentsSeparatedByString:@" "];
    if (dateAry.count == 2) {
        self.timeLab.text = [dayFormatterL stringFromDate:[dayFormatter dateFromString:dateAry[0]]];
        self.timeLab.textColor = kHexColor([[dayFormatter stringFromDate:[dayFormatter dateFromString:dateAry[0]]] isEqualToString:[dayFormatter stringFromDate:[NSDate date]]] ? @"EE273C" : @"9A9A9A", 1);
    }
}

@end
