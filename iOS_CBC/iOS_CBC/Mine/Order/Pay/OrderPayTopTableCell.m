//
//  OrderPayTopTableCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/23.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "OrderPayTopTableCell.h"

@interface OrderPayTopTableCell ()

@property (weak, nonatomic) IBOutlet UIView *titleV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIView *botV;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation OrderPayTopTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(OrderCellM *)model {
    _model = model;
    self.titleV.alpha = 0;
    self.contentV.alpha = 0;
    self.botV.alpha = 0;
    switch (model.type) {
        case 0:
            self.titleV.alpha = 1;
            self.titleLab.text = model.content;
            break;
        case 1:
            self.contentV.alpha = 1;
            self.contentLab.text = model.content;
            break;
        case 2:
            self.botV.alpha = 1;
            self.timeLab.text = model.content;
            break;
        default:
            break;
    }
}

@end
