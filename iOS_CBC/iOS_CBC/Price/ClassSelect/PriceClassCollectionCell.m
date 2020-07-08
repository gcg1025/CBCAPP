//
//  PriceClassCollectionCell.m
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/25.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import "PriceClassCollectionCell.h"

@interface PriceClassCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UIView *backgroundV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation PriceClassCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(PriceClassM *)model {
    _model = model;
    self.backgroundV.backgroundColor = kHexColor(self.isTitle ? kTintColorHex : @"DDDDDD", 1);
    self.backgroundV.alpha = self.isTitle ? 1 : (model.isSelect ? 0.5 : 1);
    self.imgV.hidden = self.isTitle ? false : model.isSelect;
    self.imgV.image = kImage(self.isTitle ? @"price_class_cell_reduce" : (model.isSelect ? @"nromal_placehold_empty" : @"price_class_cell_add"));
    self.titleLab.textColor = kHexColor(self.isTitle ? @"FFFFFF" : @"000000", 1);
    self.titleLab.text = model.name;
}

@end
