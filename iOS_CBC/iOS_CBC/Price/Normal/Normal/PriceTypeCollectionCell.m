//
//  PriceTypeCollectionCell.m
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/30.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import "PriceTypeCollectionCell.h"

@interface PriceTypeCollectionCell()

@property (weak, nonatomic) IBOutlet UIView *backgroundV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation PriceTypeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(PageTitleM *)model {
    _model = model;
    self.titleLab.text = model.name;
}

- (void)setIsCurrentType:(BOOL)isCurrentType {
    _isCurrentType = isCurrentType;
    self.backgroundV.backgroundColor = isCurrentType ? kHexColor(@"FF9018", 1) : [UIColor clearColor];
    self.titleLab.textColor = kHexColor(isCurrentType ? @"FFFFFF" : @"676767", 1);
}

- (void)setFoModel:(FOPriceM *)foModel {
    _foModel = foModel;
    self.titleLab.text = foModel.name;
}

@end
