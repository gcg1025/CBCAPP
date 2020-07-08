//
//  NewsTitleCollectionCell.m
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/30.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import "NewsTitleCollectionCell.h"

@interface NewsTitleCollectionCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *indicatorV;

@end

@implementation NewsTitleCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(NewsClassM *)model {
    _model = model;
    self.titleLab.text = model.name;
}

- (void)setIsCurrentClass:(BOOL)isCurrentClass {
    _isCurrentClass = isCurrentClass;
    self.indicatorV.hidden = !isCurrentClass;
}

@end
