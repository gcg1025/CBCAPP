//
//  EntBidPriceTableCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/19.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "EntBidPriceTableCell.h"

@interface EntBidPriceTableCell ()

@property (weak, nonatomic) IBOutlet UIView *labV;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *productLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLabWidCon;
@property (weak, nonatomic) IBOutlet UILabel *zdLab;
@property (weak, nonatomic) IBOutlet UILabel *indexLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zbLabWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneWidCon;


@end

@implementation EntBidPriceTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(PriceEntBidM *)model {
    _model = model;
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDateFormatter *dayFormatterL = [[NSDateFormatter alloc] init];
    [dayFormatterL setDateFormat:@"MM-dd"];
    NSArray *dateAry = [model.isEnt ? model.valuedate : model.pdate componentsSeparatedByString:@" "];
    if (dateAry.count == 2) {
        self.timeLab.text = [dayFormatterL stringFromDate:[dayFormatter dateFromString:dateAry[0]]];
    }
    self.nameLab.text = model.isEnt ? model.comp_simple : model.companyname;
    self.productLab.text = model.isEnt ? model.qname : model.productid_name;
    self.indexLab.attributedText = model.indexstringAttr;
    [self.labV.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag != 10000) {
            [obj removeFromSuperview];
        }
    }];
    NSMutableArray *labAry = @[].mutableCopy;
    NSString *key = model.jurID ? @(model.jurID).stringValue : model.jurIDStr;
    if (model.isEnt) {
        if ([[Tool shareInstance].user.jurDic[key] boolValue]) {
            self.priceLab.text = model.price;
            self.zdLab.text = [model.price_zde containsString:@"."] ? [NSString stringWithFormat:@"%.2f", model.price_zde.floatValue] : model.price_zde;
            UIColor *tintColor = model.price_zde.floatValue != 0 ? model.price_zde.floatValue > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
            self.priceLab.textColor = tintColor;
            self.zdLab.textColor = tintColor;
        } else {
            self.priceLab.text = @"*";
            self.zdLab.text = @"*";
            self.priceLab.textColor = [UIColor blackColor];
            self.zdLab.textColor = [UIColor blackColor];
        }
        if (model.unitname.length) {
            [labAry addObject:model.unitname];
        }
        if (model.fkfs.length) {
            [labAry addObject:model.fkfs];
        }
    } else {
        if ([[Tool shareInstance].user.jurDic[key] boolValue]) {
            self.priceLab.text = model.cg_str;
            self.zdLab.text = model.price_average;
        } else {
            self.priceLab.text = @"*";
            self.zdLab.text = @"*";
        }
        self.priceLab.textColor = [UIColor blackColor];
        self.zdLab.textColor = [UIColor blackColor];
        if (model.pdate_char.length) {
            [labAry addObject:model.pdate_char];
        }
        if (model.price_unit.length) {
            [labAry addObject:model.price_unit];
        }
        if (model.fffs.length) {
            [labAry addObject:model.fffs];
        }
    }
    CGFloat l = 10;
    for (NSString *string in labAry) {
        UILabel *lab = [[UILabel alloc] init];
        lab.text = string;
        lab.font = [UIFont systemFontOfSize:13];
        lab.textColor = kHexColor(@"245286", 1);
        lab.backgroundColor = kHexColor(@"E2EAF8", 1);
        lab.textAlignment = NSTextAlignmentCenter;
        CGFloat width = [Tool widthForString:string font:[UIFont systemFontOfSize:13]];
        lab.frame = CGRectMake(l, 0, width + 6, 20);
        l += width + 16;
        [self.labV addSubview:lab];
    }
    CGFloat kScale = (kScreenW / 360 < 1 ? 1 : kScreenW / 360);
    self.oneWidCon.constant = 80 * kScale;
    self.zbLabWidCon.constant = (model.isEnt ? 75 : 65) * kScale;
    self.zbLabWidCon.constant = (model.isEnt ? 55 : 70) * kScale;
    [self layoutIfNeeded];
}


- (IBAction)selectAct:(id)sender {
    NSString *key = self.model.jurID ? @(self.model.jurID).stringValue : self.model.jurIDStr;
    if (![[Tool shareInstance].user.jurDic[key] boolValue]) {
        if (self.selectBlock) {
            self.selectBlock();
        }
    }
}

@end
