//
//  OrderDetailsVIPContentCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/24.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "OrderDetailsVIPContentCell.h"

@interface OrderDetailsVIPContentCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@end

@implementation OrderDetailsVIPContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(OrderCellM *)model {
    if (!model) {
        return;
    }
    _model = model;
    self.contentLab.text = model.content;
}

@end
