//
//  AnalyseTitleCollectionCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/29.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "AnalyseTitleCollectionCell.h"

@interface AnalyseTitleCollectionCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation AnalyseTitleCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(NewsClassM *)model {
    _model = model;
    self.titleLab.text = model.name;
    self.titleLab.alpha = self.isCurrentClass ? 1 : 0.5;
}

@end
