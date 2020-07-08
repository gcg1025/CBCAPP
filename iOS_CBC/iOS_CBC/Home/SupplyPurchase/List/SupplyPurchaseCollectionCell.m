//
//  SupplyPurchaseCollectionCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/26.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "SupplyPurchaseCollectionCell.h"

@interface SupplyPurchaseCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *titleV;

@end

@implementation SupplyPurchaseCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(DistributionClassM *)model {
    _model = model;
    self.titleLab.text = model.name;
    self.titleLab.textColor = kHexColor(model.isSelect ? @"FFFFFF" : @"666666", 1);
    self.titleV.backgroundColor = kHexColor(model.isSelect ? @"245286" : @"E2EAF8", 1);
}

@end
