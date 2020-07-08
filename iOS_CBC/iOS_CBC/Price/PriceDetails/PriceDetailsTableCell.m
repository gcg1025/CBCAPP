//
//  PriceDetailsTableCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/8.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "PriceDetailsTableCell.h"

@interface PriceDetailsTableCell ()

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

@implementation PriceDetailsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setType:(NSInteger)type {
    _type = type;
    CGFloat kScale = (kScreenW / 360 < 1 ? 1 : kScreenW / 360);
    CGFloat widCon = 80 * kScale;
    switch (type) {
        case 1:
            self.widCon1.constant = 60 * kScale;
            widCon = (kScreenW - 60 * kScale) / 6 > widCon ? (kScreenW - 60 * kScale) / 6 : widCon;
            self.widCon2.constant = self.widCon3.constant = self.widCon4.constant = self.widCon5.constant = self.widCon6.constant = self.widCon7.constant = widCon;
            break;
        case 2:
            self.widCon1.constant = 60 * kScale;
            widCon = (kScreenW - 60 * kScale) / 6 > widCon ? (kScreenW - 60 * kScale) / 6 : widCon;
            self.widCon2.constant = self.widCon3.constant = self.widCon4.constant = self.widCon5.constant = self.widCon6.constant = self.widCon7.constant = widCon;
            break;
        case 3:
            self.widCon1.constant = 60 * kScale;
            widCon = (kScreenW - 60 * kScale) / 5 > widCon ? (kScreenW - 60 * kScale) / 5 : widCon;
            self.widCon2.constant = self.widCon3.constant = self.widCon4.constant = self.widCon5.constant = self.widCon6.constant = widCon;
            self.widCon7.constant = 0.001;
            break;
        case 4:
            self.widCon1.constant = 60 * kScale;
            widCon = (kScreenW - 60 * kScale) / 4 > widCon ? (kScreenW - 60 * kScale) / 4 : widCon;
            self.widCon2.constant = self.widCon3.constant = self.widCon4.constant = self.widCon5.constant = widCon;
            self.widCon6.constant = self.widCon7.constant = 0.001;
            break;
        case 5:
            self.widCon1.constant = 60 * kScale;
            widCon = (kScreenW - 60 * kScale) / 3 > widCon ? (kScreenW - 60 * kScale) / 3 : widCon;
            self.widCon2.constant = self.widCon3.constant = self.widCon4.constant = widCon;
            self.widCon5.constant = self.widCon6.constant = self.widCon7.constant = 0.001;
            break;
        case 6:
            self.widCon1.constant = 60 * kScale;
            widCon = (kScreenW - 60 * kScale) / 3 > widCon ? (kScreenW - 60 * kScale) / 3 : widCon;
            self.widCon2.constant = self.widCon3.constant = self.widCon4.constant = widCon;
            self.widCon5.constant = self.widCon6.constant = self.widCon7.constant = 0.001;
            break;
        case 7:
            self.widCon1.constant = 60 * kScale;
            widCon = (kScreenW - 60 * kScale) / 6 > widCon ? (kScreenW - 60 * kScale) / 6 : widCon;
            self.widCon2.constant = self.widCon3.constant = self.widCon4.constant = self.widCon5.constant = self.widCon6.constant = self.widCon7.constant = widCon;
            break;
        case 8:
            self.widCon1.constant = 60 * kScale;
            widCon = (kScreenW - 60 * kScale) / 3 > widCon ? (kScreenW - 60 * kScale) / 3 : widCon;
            self.widCon2.constant = self.widCon3.constant = self.widCon4.constant = widCon;
            self.widCon5.constant = self.widCon6.constant = self.widCon7.constant = 0.001;
            break;
        case 9:
            self.widCon1.constant = 60 * kScale;
            widCon = (kScreenW - 60 * kScale) / 6 > widCon ? (kScreenW - 60 * kScale) / 6 : widCon;
            self.widCon2.constant = self.widCon3.constant = self.widCon4.constant = self.widCon5.constant = self.widCon6.constant = self.widCon7.constant = widCon;
            break;
        default:
            self.widCon1.constant = 60 * kScale;
            widCon = (kScreenW - 60 * kScale) / 5 > widCon ? (kScreenW - 60 * kScale) / 5 : widCon;
            self.widCon2.constant = self.widCon3.constant = self.widCon4.constant = self.widCon5.constant = self.widCon6.constant = widCon;
            self.widCon7.constant = 0.001;
            break;
    }
    self.isSet = true;
    [self layoutIfNeeded];
}

- (void)setModel:(PriceDetailsPriceM *)model {
    self.lab1.text = model.price1;
    self.lab1.textColor = [UIColor blackColor];
    if (model.color1) {
        self.lab1.textColor = model.color1;
    }
    self.lab2.text = model.price2;
    self.lab2.textColor = [UIColor blackColor];
    if (model.color2) {
        self.lab2.textColor = model.color2;
    }
    self.lab3.text = model.price3;
    self.lab3.textColor = [UIColor blackColor];
    if (model.color3) {
        self.lab3.textColor = model.color3;
    }
    self.lab4.text = model.price4;
    self.lab4.textColor = [UIColor blackColor];
    if (model.color4) {
        self.lab4.textColor = model.color4;
    }
    self.lab5.text = model.price5;
    self.lab5.textColor = [UIColor blackColor];
    if (model.color5) {
        self.lab5.textColor = model.color5;
    }
    self.lab6.text = model.price6;
    self.lab6.textColor = [UIColor blackColor];
    if (model.color6) {
        self.lab6.textColor = model.color6;
    }
    self.lab7.text = model.price7;
    self.lab7.textColor = [UIColor blackColor];
    if (model.color7) {
        self.lab7.textColor = model.color7;
    }
}

@end
