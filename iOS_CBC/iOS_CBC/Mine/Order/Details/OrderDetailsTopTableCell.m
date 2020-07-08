//
//  OrderDetailsTopTableCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/24.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "OrderDetailsTopTableCell.h"

@interface OrderDetailsTopTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@end

@implementation OrderDetailsTopTableCell

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
    self.titleLab.text = model.title;
    self.stateLab.text = model.privacyModel.state.integerValue == 1 ? @"已支付" : @"未支付";
    self.priceLab.text = [NSString stringWithFormat:@"¥%@", model.privacyModel.payMoney];
}

@end
