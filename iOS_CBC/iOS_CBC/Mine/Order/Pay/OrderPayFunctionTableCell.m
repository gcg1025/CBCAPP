//
//  OrderPayFunctionTableCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/23.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "OrderPayFunctionTableCell.h"

@interface OrderPayFunctionTableCell ()

@property (weak, nonatomic) IBOutlet UIView *accountV;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgV;
@property (weak, nonatomic) IBOutlet UILabel *accountLab;
@property (weak, nonatomic) IBOutlet UILabel *bankLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountVHeiCon;

@property (nonatomic, strong) CAShapeLayer *border;

@end

@implementation OrderPayFunctionTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.border = [CAShapeLayer layer];
    self.border.strokeColor = kHexColor(@"333333", 1).CGColor;
    self.border.fillColor = [UIColor clearColor].CGColor;
    self.border.lineWidth = 0.5f;
    self.border.lineDashPattern = @[@4, @2];
    [self.accountV.layer addSublayer:self.border];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(OrderInfoM *)model {
    _model = model;
    CGRect rect = CGRectMake(0, 0, kScreenW - 32, [Tool heightForString:model.zhname width:kScreenW - 125 font:[UIFont systemFontOfSize:13]] + [Tool heightForString:model.account width:kScreenW - 125 font:[UIFont systemFontOfSize:13]] + [Tool heightForString:model.bank width:kScreenW - 125 font:[UIFont systemFontOfSize:13]] + [Tool heightForString:model.tip width:kScreenW - 52 font:[UIFont systemFontOfSize:12]] + 66);
    if (self.isChoice && self.type == OrderPayFunctionTypeBank) {
        self.accountV.alpha = 1;
        self.accountLab.text = model.account;
        self.bankLab.text = model.bank;
        self.tipLab.text = model.tip;
        self.nameLab.text = model.zhname;
        self.accountVHeiCon.constant = rect.size.height;
    } else {
        self.accountV.alpha = 0;
        self.accountVHeiCon.constant = 0.01;
    }
    
    self.border.path = [UIBezierPath bezierPathWithRect:
                        rect].CGPath;
    self.border.frame = rect;
    self.selectImgV.image = kImage(self.isChoice ? @"order_pay_select":@"order_pay_unselect");
    switch (self.type) {
        case OrderPayFunctionTypeWechat:
            self.imgV.image = kImage(@"order_pay_wechat");
            self.titleLab.text = @"微信支付";
            break;
        case OrderPayFunctionTypeAli:
            self.imgV.image = kImage(@"order_pay_ali_un");
            self.titleLab.text = @"支付宝支付";
            self.selectImgV.image = kImage(@"order_pay_unselect_un");
            break;
        case OrderPayFunctionTypeBank:
            self.imgV.image = kImage(@"order_pay_bank");
            self.titleLab.text = @"银行对公账户";
            break;
        default:
            break;
    }
    [self layoutIfNeeded];
}

@end
