//
//  TableTitleV.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/21.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "TableTitleV.h"

@interface TableTitleV ()

@property (weak, nonatomic) IBOutlet UIView *stoV;
@property (weak, nonatomic) IBOutlet UILabel *stoTitleLab;

@property (weak, nonatomic) IBOutlet UIView *fofV;
@property (weak, nonatomic) IBOutlet UIView *fofLmeV;
@property (weak, nonatomic) IBOutlet UIView *entV;
@property (weak, nonatomic) IBOutlet UIView *bidV;

@property (weak, nonatomic) IBOutlet UILabel *stoPriceLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stoOneWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stoTwoWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stoThrWidCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *entOneWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *entTwoWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *entThrWidCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bidOneWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bidTwoWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bidThrWidCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fOneWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fTwoWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fThrWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fFouWidCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lOneWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lTwoWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lThrWidCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lFouWidCon;

@end

@implementation TableTitleV

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setType:(TableTitleType)type {
    _type = type;
    self.stoV.alpha = 0;
    self.fofV.alpha = 0;
    self.fofLmeV.alpha = 0;
    self.entV.alpha = 0;
    self.bidV.alpha = 0;
    CGFloat kScale = (kScreenW / 360 < 1 ? 1 : kScreenW / 360);
    switch (type) {
        case TableTitleTypeFOO:
        case TableTitleTypeSto:
        case TableTitleTypeFOOALLNormal:
        case TableTitleTypeFOOALLSHJJS:
            self.stoV.alpha = 1;
            self.stoOneWidCon.constant = 75 * kScale;
            self.stoTwoWidCon.constant = 50 * kScale;
            self.stoThrWidCon.constant = 75 * kScale;
            if ([Tool heightForString:@"品名/价格区间" width:kScreenW - 240 * kScale font:[UIFont systemFontOfSize:13]] > 18) {
                self.stoTitleLab.text = @"品名/\n价格区间";
            }
            if (type == TableTitleTypeFOOALLNormal) {
                self.stoPriceLab.text = @"平均价";
            } else if (type == TableTitleTypeFOOALLSHJJS) {
                self.stoPriceLab.text = @"收盘价";
            }
            break;
        case TableTitleTypeEnt:
            self.entOneWidCon.constant = 80 * kScale;
            self.entTwoWidCon.constant = 75 * kScale;
            self.entThrWidCon.constant = 55 * kScale;
            self.entV.alpha = 1;
            break;
        case TableTitleTypeBid:
            self.bidOneWidCon.constant = 80 * kScale;
            self.bidTwoWidCon.constant = 65 * kScale;
            self.bidThrWidCon.constant = 70 * kScale;
            self.bidV.alpha = 1;
            break;
        case TableTitleTypeFOF:
            self.fOneWidCon.constant = 70 * kScale;
            self.fTwoWidCon.constant = 50 * kScale;
            self.fThrWidCon.constant = 60 * kScale;
            self.fFouWidCon.constant = 45 * kScale;
            self.fofV.alpha = 1;
            break;
        case TableTitleTypeFOFLME:
            self.lOneWidCon.constant = 70 * kScale;
            self.lTwoWidCon.constant = 50 * kScale;
            self.lThrWidCon.constant = 60 * kScale;
            self.lFouWidCon.constant = 45 * kScale;
            self.fofLmeV.alpha = 1;
            break;
        case TableTitleTypeFOFALL:
            self.fOneWidCon.constant = 70 * kScale;
            self.fTwoWidCon.constant = 50 * kScale;
            self.fThrWidCon.constant = 65 * kScale;
            self.fFouWidCon.constant = 60 * kScale;
            self.fofV.alpha = 1;
            ((UILabel *)[self.fofV viewWithTag:12000]).text = [NSString stringWithFormat:@"品名[%@]", self.dateStr];
            ((UILabel *)[self.fofV viewWithTag:12001]).text = @"收盘";
            ((UILabel *)[self.fofV viewWithTag:12002]).text = @"涨跌额";
            ((UILabel *)[self.fofV viewWithTag:12003]).text = @"单位";
            ((UILabel *)[self.fofV viewWithTag:12004]).text = @"成交量";
            break;
        case TableTitleTypeFOFALLLEMNormal:
            self.fOneWidCon.constant = 70 * kScale;
            self.fTwoWidCon.constant = 50 * kScale;
            self.fThrWidCon.constant = 65 * kScale;
            self.fFouWidCon.constant = 60 * kScale;
            self.fofV.alpha = 1;
            ((UILabel *)[self.fofV viewWithTag:12000]).text = [NSString stringWithFormat:@"品名[%@]", self.dateStr];
            ((UILabel *)[self.fofV viewWithTag:12001]).text = @"卖出价";
            ((UILabel *)[self.fofV viewWithTag:12002]).text = @"涨跌额";
            ((UILabel *)[self.fofV viewWithTag:12003]).text = @"涨跌幅";
            ((UILabel *)[self.fofV viewWithTag:12004]).text = @"单位";
            break;
        case TableTitleTypeFOFALLLEM:
            self.fOneWidCon.constant = 70 * kScale;
            self.fTwoWidCon.constant = 50 * kScale;
            self.fThrWidCon.constant = 65 * kScale;
            self.fFouWidCon.constant = 60 * kScale;
            self.fofV.alpha = 1;
            ((UILabel *)[self.fofV viewWithTag:12000]).text = [NSString stringWithFormat:@"品名[%@]", self.dateStr];
            ((UILabel *)[self.fofV viewWithTag:12001]).text = @"收盘价";
            ((UILabel *)[self.fofV viewWithTag:12002]).text = @"涨跌额";
            ((UILabel *)[self.fofV viewWithTag:12003]).text = @"涨跌幅";
            ((UILabel *)[self.fofV viewWithTag:12004]).text = @"单位";
            break;
        case TableTitleTypeFOFALLTOCOM:
            self.fOneWidCon.constant = 80 * kScale;
            self.fTwoWidCon.constant = 50 * kScale;
            self.fThrWidCon.constant = 1 * kScale;
            self.fFouWidCon.constant = 60 * kScale;
            self.fofV.alpha = 1;
            ((UILabel *)[self.fofV viewWithTag:12000]).text = [NSString stringWithFormat:@"品名[%@]", self.dateStr];
            ((UILabel *)[self.fofV viewWithTag:12001]).text = @"收盘[日元/克]";
            ((UILabel *)[self.fofV viewWithTag:12002]).text = @"涨跌额";
            ((UILabel *)[self.fofV viewWithTag:12003]).text = @"";
            ((UILabel *)[self.fofV viewWithTag:12004]).text = @"成交量";
            break;
        case TableTitleTypeFOOALLNFXG:
        case TableTitleTypeFOOALLLDGJS:
            self.fOneWidCon.constant = 75 * kScale;
            self.fTwoWidCon.constant = 50 * kScale;
            self.fThrWidCon.constant = 75 * kScale;
            self.fFouWidCon.constant = 45 * kScale;
            self.fofV.alpha = 1;
            ((UILabel *)[self.fofV viewWithTag:12000]).text = @"品名/指标";
            if (type == TableTitleTypeFOOALLNFXG) {
                ((UILabel *)[self.fofV viewWithTag:12001]).text = @"收盘价";
            } else if (type == TableTitleTypeFOOALLLDGJS) {
                ((UILabel *)[self.fofV viewWithTag:12001]).text = @"定盘价";
            }
            ((UILabel *)[self.fofV viewWithTag:12002]).text = @"涨跌额";
            ((UILabel *)[self.fofV viewWithTag:12003]).text = @"单位";
            ((UILabel *)[self.fofV viewWithTag:12004]).text = @"日期";
            break;
        default:
            break;
    }
    [self layoutIfNeeded];
}

- (IBAction)selectAct:(id)sender {
    if (self.selectBlock) {
        self.selectBlock();
    }
}

@end
