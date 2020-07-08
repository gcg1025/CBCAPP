//
//  PriceDetailsTitleV.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/8.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "PriceDetailsTitleV.h"

@interface PriceDetailsTitleV ()

@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UILabel *lab5;
@property (weak, nonatomic) IBOutlet UILabel *lab6;
@property (weak, nonatomic) IBOutlet UILabel *lab7;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widCon1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widCon2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widCon3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widCon4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widCon5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widCon6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widCon7;

@end

@implementation PriceDetailsTitleV

- (void)setType:(PriceDetailsTitleType)type {
    _type = type;
    CGFloat kScale = (kScreenW / 360 < 1 ? 1 : kScreenW / 360);
    CGFloat widCon = 80 * kScale;
    switch (type) {
        case PriceDetailsTitleType1:
            self.lab1.text = @"日期";
            self.lab2.text = @"开盘价";
            self.lab3.text = @"收盘价";
            self.lab4.text = @"涨幅(%)";
            self.lab5.text = @"结算价";
            self.lab6.text = @"成交量";
            self.lab7.text = @"空盘量";
            self.widCon1.constant = 60 * kScale;
            widCon = (kScreenW - 60 * kScale) / 6 > widCon ? (kScreenW - 60 * kScale) / 6 : widCon;
            self.widCon2.constant = self.widCon3.constant = self.widCon4.constant = self.widCon5.constant = self.widCon6.constant = self.widCon7.constant = widCon;
            break;
        case PriceDetailsTitleType2:
            self.lab1.text = @"日期";
            self.lab2.text = @"买入价";
            self.lab3.text = @"涨跌";
            self.lab4.text = @"涨幅(%)";
            self.lab5.text = @"卖出价";
            self.lab6.text = @"涨跌";
            self.lab7.text = @"涨幅(%)";
            self.widCon1.constant = 60 * kScale;
            widCon = (kScreenW - 60 * kScale) / 6 > widCon ? (kScreenW - 60 * kScale) / 6 : widCon;
            self.widCon2.constant = self.widCon3.constant = self.widCon4.constant = self.widCon5.constant = self.widCon6.constant = self.widCon7.constant = widCon;
            break;
        case PriceDetailsTitleType3:
            self.lab1.text = @"日期";
            self.lab2.text = @"最低价";
            self.lab3.text = @"最高价";
            self.lab4.text = @"平均价";
            self.lab5.text = @"涨跌";
            self.lab6.text = @"涨幅(%)";
            self.lab7.text = @"";
            self.widCon1.constant = 60 * kScale;
            widCon = (kScreenW - 60 * kScale) / 5 > widCon ? (kScreenW - 60 * kScale) / 5 : widCon;
            self.widCon2.constant = self.widCon3.constant = self.widCon4.constant = self.widCon5.constant = self.widCon6.constant = widCon;
            self.widCon7.constant = 0.001;
            break;
        case PriceDetailsTitleType4:
            self.lab1.text = @"日期";
            self.lab2.text = @"最低价";
            self.lab3.text = @"最高价";
            self.lab4.text = @"平均价";
            self.lab5.text = @"涨跌";
            self.lab6.text = @"";
            self.lab7.text = @"";
            self.widCon1.constant = 60 * kScale;
            widCon = (kScreenW - 60 * kScale) / 4 > widCon ? (kScreenW - 60 * kScale) / 4 : widCon;
            self.widCon2.constant = self.widCon3.constant = self.widCon4.constant = self.widCon5.constant = widCon;
            self.widCon6.constant = self.widCon7.constant = 0.001;
            break;
        case PriceDetailsTitleType5:
            self.lab1.text = @"日期";
            self.lab2.text = @"定盘价";
            self.lab3.text = @"结算平均价";
            self.lab4.text = @"涨跌";
            self.lab5.text = @"";
            self.lab6.text = @"";
            self.lab7.text = @"";
            self.widCon1.constant = 60 * kScale;
            widCon = (kScreenW - 60 * kScale) / 3 > widCon ? (kScreenW - 60 * kScale) / 3 : widCon;
            self.widCon2.constant = self.widCon3.constant = self.widCon4.constant = widCon;
            self.widCon5.constant = self.widCon6.constant = self.widCon7.constant = 0.001;
            break;
        case PriceDetailsTitleType6:
            self.lab1.text = @"日期";
            self.lab2.text = @"收盘价";
            self.lab3.text = @"涨跌";
            self.lab4.text = @"涨幅(%)";
            self.lab5.text = @"";
            self.lab6.text = @"";
            self.lab7.text = @"";
            self.widCon1.constant = 60 * kScale;
            widCon = (kScreenW - 60 * kScale) / 3 > widCon ? (kScreenW - 60 * kScale) / 3 : widCon;
            self.widCon2.constant = self.widCon3.constant = self.widCon4.constant = widCon;
            self.widCon5.constant = self.widCon6.constant = self.widCon7.constant = 0.001;
            break;
        case PriceDetailsTitleType7:
            self.lab1.text = @"日期";
            self.lab2.text = @"买入价";
            self.lab3.text = @"卖出价";
            self.lab4.text = @"最高价";
            self.lab5.text = @"最低价";
            self.lab6.text = @"平均价";
            self.lab7.text = @"涨跌";
            self.widCon1.constant = 60 * kScale;
            widCon = (kScreenW - 60 * kScale) / 6 > widCon ? (kScreenW - 60 * kScale) / 6 : widCon;
            self.widCon2.constant = self.widCon3.constant = self.widCon4.constant = self.widCon5.constant = self.widCon6.constant = self.widCon7.constant = widCon;
            break;
        case PriceDetailsTitleType8:
            self.lab1.text = @"日期";
            self.lab2.text = @"定盘价";
            self.lab3.text = @"涨跌";
            self.lab4.text = @"涨幅(%)";
            self.lab5.text = @"";
            self.lab6.text = @"";
            self.lab7.text = @"";
            self.widCon1.constant = 60 * kScale;
            widCon = (kScreenW - 60 * kScale) / 3 > widCon ? (kScreenW - 60 * kScale) / 3 : widCon;
            self.widCon2.constant = self.widCon3.constant = self.widCon4.constant = widCon;
            self.widCon5.constant = self.widCon6.constant = self.widCon7.constant = 0.001;
            break;
        case PriceDetailsTitleType9:
            self.lab1.text = @"日期";
            self.lab2.text = @"开盘价";
            self.lab3.text = @"最高价";
            self.lab4.text = @"最低价";
            self.lab5.text = @"收盘价";
            self.lab6.text = @"涨跌";
            self.lab7.text = @"涨幅(%)";
            self.widCon1.constant = 60 * kScale;
            widCon = (kScreenW - 60 * kScale) / 6 > widCon ? (kScreenW - 60 * kScale) / 6 : widCon;
            self.widCon2.constant = self.widCon3.constant = self.widCon4.constant = self.widCon5.constant = self.widCon6.constant = self.widCon7.constant = widCon;
            break;
        default:
            self.lab1.text = @"日期";
            self.lab2.text = @"最低价";
            self.lab3.text = @"最高价";
            self.lab4.text = @"平均价";
            self.lab5.text = @"涨跌";
            self.lab6.text = @"涨幅(%)";
            self.lab7.text = @"";
            self.widCon1.constant = 60 * kScale;
            widCon = (kScreenW - 60 * kScale) / 5 > widCon ? (kScreenW - 60 * kScale) / 5 : widCon;
            self.widCon2.constant = self.widCon3.constant = self.widCon4.constant = self.widCon5.constant = self.widCon6.constant = widCon;
            self.widCon7.constant = 0.001;
            break;
    }
    [self layoutIfNeeded];
}

@end
