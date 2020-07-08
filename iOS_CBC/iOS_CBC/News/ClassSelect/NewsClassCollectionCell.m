//
//  NewsClassCollectionCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/29.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "NewsClassCollectionCell.h"

@interface NewsClassCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UIView *backgroundV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation NewsClassCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(NewsClassM *)model {
    _model = model;
    self.backgroundV.backgroundColor = kHexColor(self.isTitle ? kTintColorHex : @"DDDDDD", 1);
    self.backgroundV.alpha = self.isTitle ? 1 : (model.isSelect ? 0.5 : 1);
    self.imgV.hidden = self.isTitle ? false : model.isSelect;
    self.imgV.image = kImage(self.isTitle ? @"price_class_cell_reduce" : (model.isSelect ? @"nromal_placehold_empty" : @"price_class_cell_add"));
    self.titleLab.textColor = kHexColor(self.isTitle ? @"FFFFFF" : @"000000", 1);
    self.titleLab.text = model.name;
}

@end
