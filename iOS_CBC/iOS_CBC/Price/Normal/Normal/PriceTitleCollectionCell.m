//
//  PriceTitleCollectionCell.m
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/25.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import "PriceTitleCollectionCell.h"

@interface PriceTitleCollectionCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation PriceTitleCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(PriceClassM *)model {
    _model = model;
    self.titleLab.text = model.name;
    self.titleLab.alpha = self.isCurrentClass ? 1 : 0.5;
}

@end
