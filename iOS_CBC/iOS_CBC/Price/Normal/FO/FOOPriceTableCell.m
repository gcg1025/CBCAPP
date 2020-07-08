//
//  FOOPriceTableCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/21.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "FOOPriceTableCell.h"

@interface FOOPriceTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *mmPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *avePriceLab;
@property (weak, nonatomic) IBOutlet UILabel *zdPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *unitLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thrWidCon;
@property (weak, nonatomic) IBOutlet UIView *normalV;
@property (weak, nonatomic) IBOutlet UIView *oAllV;

@property (weak, nonatomic) IBOutlet UILabel *oNameLab;
@property (weak, nonatomic) IBOutlet UILabel *oPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *oZDLab;
@property (weak, nonatomic) IBOutlet UILabel *oUnitLab;
@property (weak, nonatomic) IBOutlet UILabel *oIndexLab;
@property (weak, nonatomic) IBOutlet UILabel *oTimeLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oOneWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oTwoWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oThrWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oFouWidCon;

@end

@implementation FOOPriceTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(PriceFOM *)model {
    _model = model;
    CGFloat kScale = (kScreenW / 360 < 1 ? 1 : kScreenW / 360);
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDateFormatter *dayFormatterL = [[NSDateFormatter alloc] init];
    [dayFormatterL setDateFormat:@"MM-dd"];
    NSArray *dateAry = [model.valuedate componentsSeparatedByString:@" "];
    if (self.isOAll) {
        self.oAllV.alpha = 1;
        self.normalV.alpha = 0;
        if (dateAry.count == 2) {
            self.oTimeLab.text = [dayFormatterL stringFromDate:[dayFormatter dateFromString:dateAry[0]]];
        }
        self.oNameLab.attributedText = model.qnameAttr;
        self.oIndexLab.text = model.indexstring;
        if ([[Tool shareInstance].user.jurDic[@(model.jurID).stringValue] boolValue]) {
            NSString *avgPrice = [model.priceFoContentM.avg containsString:@"."] ? [NSString stringWithFormat:@"%.2f", model.priceFoContentM.avg.floatValue] : model.priceFoContentM.avg;
            if (!avgPrice) {
                avgPrice = @"0";
            }
            self.oPriceLab.text = avgPrice;
            CGFloat zde = model.priceFoContentM.zde.floatValue;
            NSString *zdPrice = [model.priceFoContentM.zde containsString:@"."] ? [NSString stringWithFormat:@"%.2f", model.priceFoContentM.zde.floatValue] : model.priceFoContentM.zde;
            if (!zdPrice) {
                zdPrice = @"0";
            }
            self.oZDLab.text = zde > 0 ? [NSString stringWithFormat:@"+%@", zdPrice] : zdPrice;
            UIColor *tintColor = zde ? zde > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
            self.oPriceLab.textColor = tintColor;
            self.oZDLab.textColor = tintColor;
        } else {
            self.oPriceLab.text = @"*";
            self.oZDLab.text = @"*";
            self.oPriceLab.textColor = [UIColor blackColor];
            self.oZDLab.textColor = [UIColor blackColor];
        }
        self.oUnitLab.text = model.typeName.length ? model.typeName : ([model.zsunitname isEqualToString:@"目录开始"] ? @"" : model.zsunitname);
        self.oOneWidCon.constant = kScale * 75;
        self.oTwoWidCon.constant = kScale * 50;
        self.oThrWidCon.constant = kScale * 75;
        self.oFouWidCon.constant = kScale * 45;
        [self layoutIfNeeded];
    } else {
        self.oAllV.alpha = 0;
        self.normalV.alpha = 1;
        self.nameLab.attributedText = model.qnameAttr;
        if (dateAry.count == 2) {
            self.timeLab.text = [dayFormatterL stringFromDate:[dayFormatter dateFromString:dateAry[0]]];
        }
        if ([[Tool shareInstance].user.jurDic[@(model.jurID).stringValue] boolValue]) {
            self.mmPriceLab.text = model.priceFoContentM.priceStr;
            NSString *avgPrice = [model.priceFoContentM.avg containsString:@"."] ? [NSString stringWithFormat:@"%.2f", model.priceFoContentM.avg.floatValue] : model.priceFoContentM.avg;
            if (!avgPrice) {
                avgPrice = @"0";
            }
            self.avePriceLab.text = avgPrice;
            CGFloat zde = model.priceFoContentM.zde.floatValue;
            NSString *zdPrice = [model.priceFoContentM.zde containsString:@"."] ? [NSString stringWithFormat:@"%.2f", model.priceFoContentM.zde.floatValue] : model.priceFoContentM.zde;
            if (!zdPrice) {
                zdPrice = @"0";
            }
            self.zdPriceLab.text = zde > 0 ? [NSString stringWithFormat:@"+%@", zdPrice] : zdPrice;
            UIColor *tintColor = zde ? zde > 0 ? kHexColor(@"E5352E", 1) : kHexColor(@"008F00", 1) : [UIColor blackColor];
            self.mmPriceLab.textColor = tintColor;
            self.avePriceLab.textColor = tintColor;
            self.zdPriceLab.textColor = tintColor;
        } else {
            self.mmPriceLab.text = @"*-*";
            self.avePriceLab.text = @"*";
            self.zdPriceLab.text = @"*";
            self.mmPriceLab.textColor = [UIColor blackColor];
            self.avePriceLab.textColor = [UIColor blackColor];
            self.zdPriceLab.textColor = [UIColor blackColor];
        }
        self.unitLab.text = model.typeName.length ? model.typeName : ([model.zsunitname isEqualToString:@"目录开始"] ? @"" : model.zsunitname);
        self.oneWidCon.constant = kScale * 75;
        self.twoWidCon.constant = kScale * 50;
        self.thrWidCon.constant = kScale * 75;
        [self layoutIfNeeded];
    }
}

- (IBAction)selectAct:(id)sender {
    if (self.selectBlock) {
        self.selectBlock(self.model);
    }
}

@end
