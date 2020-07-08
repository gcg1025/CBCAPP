//
//  FOFPriceTableCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/21.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "FOFPriceTableCell.h"
#import "TableTitleV.h"

@interface FOFPriceTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *zdLab;
@property (weak, nonatomic) IBOutlet UILabel *thiLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thrWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fouWidCon;

@end

@implementation  FOFPriceTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    TableTitleV *tableTitleV = [[NSBundle mainBundle] loadNibNamed:@"TableTitleV" owner:nil options:nil].firstObject;
    tableTitleV.frame = CGRectMake(0, 0, kScreenW, 40);
    tableTitleV.tag = 10000;
    [self.contentView addSubview:tableTitleV];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(PriceFOM *)model {
    _model = model;
    CGFloat kScale = (kScreenW / 360 < 1 ? 1 : kScreenW / 360);
    self.oneWidCon.constant = 70 * kScale;
    if (model.ID != 0) {
        self.nameLab.text = model.qname;
        if (self.type == 0) {
            NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
            [dayFormatter setDateFormat:@"yyyy/MM/dd"];
            NSDateFormatter *dayFormatterL = [[NSDateFormatter alloc] init];
            [dayFormatterL setDateFormat:@"MM-dd"];
            NSArray *dateAry = [model.valuedate componentsSeparatedByString:@" "];
            if (dateAry.count == 2) {
                self.timeLab.text = [dayFormatterL stringFromDate:[dayFormatter dateFromString:dateAry[0]]];
            }
        }
        if ([[Tool shareInstance].user.jurDic[@(model.jurID).stringValue] boolValue]) {
            self.priceLab.text = model.priceFoContentM.priceStr;
            CGFloat zde = model.priceFoContentM.zde.floatValue;
            NSString *zdPrice = [model.priceFoContentM.zde containsString:@"."] ? [NSString stringWithFormat:@"%.2f", model.priceFoContentM.zde.floatValue] : model.priceFoContentM.zde;
            if (!zdPrice) {
                zdPrice = @"0";
            }
            self.zdLab.text = zde > 0 ? [NSString stringWithFormat:@"+%@", zdPrice] : zdPrice;
            NSString *thiStr = @"";
            if (self.type == FuturePriceTypeLEM) {
                thiStr = [model.priceFoContentM.zdf stringByReplacingOccurrencesOfString:@"-" withString:@""];
                thiStr = [NSString stringWithFormat:@"%@%.2f", zde < 0 ? @"-" : @"", thiStr.floatValue];
            } else {
                if (!model.isLME || (model.jurID == 10643 || model.jurID == 10763 || model.jurID == 10114 || model.jurID == 13889)) {
                    thiStr = model.priceFoContentM.trade;
                } else {
                    thiStr = [model.priceFoContentM.zdf stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    thiStr = [NSString stringWithFormat:@"%@%.2f", zde < 0 ? @"-" : @"", thiStr.floatValue];
                }
            }
            UIColor *tintColor = zde ? zde > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
            self.priceLab.textColor = tintColor;
            self.zdLab.textColor = tintColor;
            if (self.type == FuturePriceTypeNormal || self.type == FuturePriceTypeTOCOM) {
                self.thiLab.textColor = [UIColor blackColor];
                self.timeLab.textColor = tintColor;
                self.thiLab.font = [UIFont systemFontOfSize:15];
                self.timeLab.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
                self.timeLab.text = thiStr;
                if (self.type == FuturePriceTypeTOCOM) {
                    self.thiLab.text = @" ";
                    self.oneWidCon.constant = 80 * kScale;
                    self.thrWidCon.constant = 1 * kScale;
                } else {
                    self.thiLab.text = model.typeName;
                    self.thrWidCon.constant = 65 * kScale;
                }
                self.fouWidCon.constant = 60 * kScale;
            } else {
                self.thiLab.textColor = tintColor;
                self.timeLab.textColor = [UIColor blackColor];
                self.thiLab.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
                self.timeLab.font = [UIFont systemFontOfSize:15];
                self.thiLab.text = thiStr;
                self.thrWidCon.constant = 60 * kScale;
                if (self.type == FuturePriceTypeLEM) {
                    self.timeLab.text = model.typeName;
                    self.fouWidCon.constant = 65 * kScale;
                } else {
                    self.fouWidCon.constant = 45 * kScale;
                }
            }
        } else {
            self.priceLab.text = @"*";
            self.zdLab.text = @"*";
            self.priceLab.textColor = [UIColor blackColor];
            self.zdLab.textColor = [UIColor blackColor];
            self.thiLab.textColor = [UIColor blackColor];
            self.timeLab.textColor = [UIColor blackColor];
            if (self.type == FuturePriceTypeNormal || self.type == FuturePriceTypeTOCOM) {
                self.thiLab.font = [UIFont systemFontOfSize:15];
                self.timeLab.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
                self.timeLab.text = @"*";
                if (self.type == FuturePriceTypeTOCOM) {
                    self.thiLab.text = @" ";
                    self.thrWidCon.constant = 1 * kScale;
                } else {
                    self.thiLab.text = model.typeName;
                    self.thrWidCon.constant = 65 * kScale;
                }
                self.fouWidCon.constant = 60 * kScale;
            } else {
                self.thiLab.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
                self.timeLab.font = [UIFont systemFontOfSize:15];
                self.thiLab.text = @"*";
                if (self.type == FuturePriceTypeLEM) {
                    self.timeLab.text = model.typeName;
                    self.fouWidCon.constant = 65 * kScale;
                } else {
                    self.fouWidCon.constant = 45 * kScale;
                }
                self.thrWidCon.constant = 60 * kScale;
            }
        }
    }
    TableTitleV *tableTitleV = [self.contentView viewWithTag:10000];
    if (self.type == FuturePriceTypeNo) {
        tableTitleV.type = TableTitleTypeFOFLME;
    } else {
        NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
        [dayFormatter setDateFormat:@"yyyy/MM/dd"];
        NSDateFormatter *dayFormatterL = [[NSDateFormatter alloc] init];
        [dayFormatterL setDateFormat:@"MM-dd"];
        NSArray *dateAry = [model.valuedate componentsSeparatedByString:@" "];
        if (dateAry.count == 2) {
            tableTitleV.dateStr = [dayFormatterL stringFromDate:[dayFormatter dateFromString:dateAry[0]]];
        }
        tableTitleV.type = TableTitleTypeFOFALLLEM;
    }
    tableTitleV.alpha = model.ID != 0 ? 0 : 1;
    self.twoWidCon.constant = 50 * kScale;
    [self layoutIfNeeded];
}

- (IBAction)selectAct:(id)sender {
    if (self.selectBlock) {
        self.selectBlock(self.model);
    }
}

@end
