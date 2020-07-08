//
//  FOPriceClassCollectionCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/8.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "FOPriceClassCollectionCell.h"

@interface FOPriceClassCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation FOPriceClassCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(FOPriceM *)model {
    _model = model;
    self.nameLab.text = model.name;
    self.nameLab.layer.borderWidth = 1;
    self.nameLab.layer.borderColor = kHexColor(model.isSelect ? @"FF9018" : @"CCCCCC", 1).CGColor;
    self.nameLab.backgroundColor = kHexColor(model.isSelect ? @"FF9018" : @"FFFFFF", 1);
    self.nameLab.textColor = kHexColor(model.isSelect ? @"FFFFFF" : @"333333", 1);
}

@end
