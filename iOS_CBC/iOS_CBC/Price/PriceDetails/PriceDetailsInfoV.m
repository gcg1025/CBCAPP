//
//  PriceDetailsInfoV.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/8.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "PriceDetailsInfoV.h"

@interface PriceDetailsInfoV ()

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *indexLab;
@property (weak, nonatomic) IBOutlet UILabel *placeProductLab;
@property (weak, nonatomic) IBOutlet UILabel *placeTradeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *payFunctionLab;
@property (weak, nonatomic) IBOutlet UILabel *orgnizationLab;
@property (weak, nonatomic) IBOutlet UILabel *orgnizationTitleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeiCon;

@end

@implementation PriceDetailsInfoV

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
}

- (void)setModel:(PriceDetailsM *)model {
    _model = model;
    CGFloat height = 66;
    self.nameLab.text = model.qname;
    if (model.qname.length) {
        height += [Tool heightForString:model.qname width:kScreenW - 100 font:[UIFont systemFontOfSize:15]] + 15;
    } else {
        self.nameLab.text = @" ";
        height += 33;
    }
    self.indexLab.attributedText = [Tool htmlTranslat:model.indexstring font:[UIFont systemFontOfSize:15]];
//    self.indexLab.text = model.indexstring;
    if (model.indexstring.length) {
        height += [Tool heightForString:self.indexLab.attributedText.string width:kScreenW - 100 font:[UIFont systemFontOfSize:15]] + 15;
    } else {
        self.indexLab.text = @" ";
        height += 33;
    }
    self.placeProductLab.text = model.placePruduct;
    if (model.placePruduct.length) {
        height += [Tool heightForString:model.placePruduct width:kScreenW - 100 font:[UIFont systemFontOfSize:15]] + 15;
    } else {
        self.placeProductLab.text = @" ";
        height += 33;
    }
    self.placeTradeLab.text = model.placeTrade;
    if (model.placeTrade.length) {
        height += [Tool heightForString:model.placeTrade width:kScreenW - 115.5 font:[UIFont systemFontOfSize:15]] + 15;
    } else {
        self.placeTradeLab.text = @" ";
        height += 33;
    }
    self.priceTypeLab.text = model.pricetypename;
    if (model.pricetypename.length) {
        height += [Tool heightForString:model.pricetypename width:kScreenW - 130.5 font:[UIFont systemFontOfSize:15]] + 15;
    } else {
        self.priceTypeLab.text = @" ";
        height += 33;
    }
    self.payFunctionLab.text = model.payFunction;
    if (model.payFunction.length) {
        height += [Tool heightForString:model.payFunction width:kScreenW - 130.5 font:[UIFont systemFontOfSize:15]] + 15;
    } else {
        self.payFunctionLab.text = @" ";
        height += 33;
    }
    self.orgnizationLab.text = model.bjjgname;
    if (model.bjjgname.length) {
        self.orgnizationTitleLab.alpha = 1;
        self.orgnizationLab.alpha = 1;
        height += [Tool heightForString:model.payFunction width:kScreenW - 130.5 font:[UIFont systemFontOfSize:15]] + 15;
    } else {
        self.orgnizationTitleLab.alpha = 0;
        self.orgnizationLab.alpha = 0;
    }
    self.contentHeiCon.constant = height;
    [self layoutIfNeeded];
}

- (void)hideView {
    self.alpha = 0;
}

- (void)showView {
    kWeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 1;
    }];
}

- (IBAction)closeAct:(id)sender {
    [self hideView];
}

@end
