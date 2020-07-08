//
//  PriceEntClassCollectionCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/22.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "PriceEntClassCollectionCell.h"

@interface PriceEntClassCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation PriceEntClassCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(PriceModelM *)model {
    _model = model;
    self.nameLab.text = model.productSmallName;
    self.nameLab.layer.borderWidth = 1;
    self.nameLab.layer.borderColor = kHexColor(model.isSelect ? @"FF9018" : @"CCCCCC", 1).CGColor;
    self.nameLab.backgroundColor = kHexColor(model.isSelect ? @"FF9018" : @"FFFFFF", 1);
    self.nameLab.textColor = kHexColor(model.isSelect ? @"FFFFFF" : @"333333", 1);
}

@end
