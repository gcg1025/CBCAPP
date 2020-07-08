//
//  NewsClassTableCell.m
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/30.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import "NewsClassTableCell.h"

@interface NewsClassTableCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *selectImg;

@end

@implementation NewsClassTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(NewsClassM *)model {
    _model = model;
    self.backgroundColor = kHexColor(@"F0F0F0", 1);
    self.titleLab.text = model.name;
    self.selectImg.image = kImage(model.isSelect ? @"news_class_select" : @"news_class_default");
}


@end
