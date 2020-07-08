//
//  OrderPayNoTimeTableCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/25.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "OrderPayNoTimeTableCell.h"

@interface OrderPayNoTimeTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation OrderPayNoTimeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDuration:(NSString *)duration {
    _duration = duration;
    self.titleLab.text = [NSString stringWithFormat:@"订购时间：%@年", duration];
}

@end
