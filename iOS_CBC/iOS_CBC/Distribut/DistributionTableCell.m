//
//  DistributionTableCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/25.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "DistributionTableCell.h"

@interface DistributionTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgV;

@end

@implementation DistributionTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(DistributionM *)model {
    _model = model;
    self.titleLab.attributedText = model.name;
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDateFormatter *dayFormatterL = [[NSDateFormatter alloc] init];
    [dayFormatterL setDateFormat:@"YYYY-MM-dd"];
    NSArray *dateAry = [model.sysdate componentsSeparatedByString:@" "];
    if (dateAry.count == 2) {
        self.timeLab.text = [dayFormatterL stringFromDate:[dayFormatter dateFromString:dateAry[0]]];
    }
    if (model.isuse) {
        self.stateLab.text = @[@"审核中", @"未通过", @"已通过", @"已过期", @"未审核"][model.state];
        self.stateLab.textColor = ((NSArray<UIColor *> *)@[kHexColor(@"245286", 1), kHexColor(@"C80000", 1), kHexColor(@"008F00", 1), kHexColor(@"000000", 1), kHexColor(@"000000", 1)])[model.state];
    } else {
        self.stateLab.text = @"禁止";
        self.stateLab.textColor = kHexColor(@"C80000", 1);
    }
    self.selectImgV.image = kImage(model.isSelect ? @"distribution_select" : @"distribution_unselect");
}

- (IBAction)selectAct:(id)sender {
    self.model.isSelect = !self.model.isSelect;
    self.selectImgV.image = kImage(self.model.isSelect ? @"distribution_select" : @"distribution_unselect");
    if (self.selectBlock) {
        self.selectBlock(self.model);
    }
}

- (IBAction)modifyAct:(id)sender {
    if (self.modifyBlock) {
        self.modifyBlock(self.model);
    }
}

@end
