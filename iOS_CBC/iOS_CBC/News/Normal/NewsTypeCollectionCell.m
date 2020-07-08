//
//  NewsTypeCollectionCell.m
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/30.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import "NewsTypeCollectionCell.h"

@interface NewsTypeCollectionCell()

@property (weak, nonatomic) IBOutlet UIView *backgroundV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation NewsTypeCollectionCell

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
    self.backgroundV.backgroundColor = kHexColor(isCurrentType ? @"FFFFFF" : @"245286", 1);
    self.titleLab.textColor = kHexColor(isCurrentType ? @"676767" : @"FFFFFF", 1);
}

@end
