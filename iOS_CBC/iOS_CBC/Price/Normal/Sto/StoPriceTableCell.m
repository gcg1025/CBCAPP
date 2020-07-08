//
//  StoPriceTableCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/19.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "StoPriceTableCell.h"

@interface StoPriceTableCell ()

@property (weak, nonatomic) IBOutlet UIView *topV;
@property (weak, nonatomic) IBOutlet UIView *otherV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *mmPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *avePriceLab;
@property (weak, nonatomic) IBOutlet UILabel *zdPriceLab;

@property (weak, nonatomic) IBOutlet UILabel *unitLab;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actV;
@property (weak, nonatomic) IBOutlet UILabel *noDataLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thrWidCon;

@end

@implementation StoPriceTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(PriceStoM *)model {
    _model = model;
    self.topV.alpha = 1;
    self.otherV.alpha = 0;
    self.nameLab.attributedText = model.qnameAttr;
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDateFormatter *dayFormatterL = [[NSDateFormatter alloc] init];
    [dayFormatterL setDateFormat:@"MM-dd"];
    NSArray *dateAry = [model.valuedate componentsSeparatedByString:@" "];
    if (dateAry.count == 2) {
        self.timeLab.text = [dayFormatterL stringFromDate:[dayFormatter dateFromString:dateAry[0]]];
    }
    if ([[Tool shareInstance].user.jurDic[@(model.jurID).stringValue] boolValue]) {
        self.mmPriceLab.text = model.priceStoContentM.priceStr;
        NSString *avgPrice = [model.priceStoContentM.price_avg containsString:@"."] ? [NSString stringWithFormat:@"%.2f", model.priceStoContentM.price_avg.floatValue] : model.priceStoContentM.price_avg;
        if (!avgPrice) {
            avgPrice = @"0";
        }
        self.avePriceLab.text = avgPrice;
        CGFloat zde = model.priceStoContentM.price_zde.floatValue;
        NSString *zdPrice = [model.priceStoContentM.price_zde containsString:@"."] ? [NSString stringWithFormat:@"%.2f", model.priceStoContentM.price_zde.floatValue] : model.priceStoContentM.price_zde;
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
    CGFloat kScale = (kScreenW / 360 < 1 ? 1 : kScreenW / 360);
    self.oneWidCon.constant = kScale * 75;
    self.twoWidCon.constant = kScale * 50;
    self.thrWidCon.constant = kScale * 75;
    [self layoutIfNeeded];
}

- (void)setRequestOrNodataIsRequest:(BOOL)requestOrNodataIsRequest {
    _requestOrNodataIsRequest = requestOrNodataIsRequest;
    self.topV.alpha = 0;
    self.otherV.alpha = 1;
    self.actV.alpha = requestOrNodataIsRequest ? 1 : 0;
    self.noDataLab.alpha = requestOrNodataIsRequest ? 0 : 1;
    [self.actV startAnimating];
}

- (IBAction)selectAct:(id)sender {
    if (self.selectBlock) {
        self.selectBlock(self.model);
    }
}

@end
