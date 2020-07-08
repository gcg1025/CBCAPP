//
//  PriceTipV.m
//  SDB_Optimize
//
//  Created by SDB_Mac on 2020/6/16.
//  Copyright © 2020 Regent. All rights reserved.
//

#import "PriceTipV.h"

@interface PriceTipV ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topVHeiCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topVLefCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topVRigCon;
@property (weak, nonatomic) IBOutlet UIView *topLineV;
@property (weak, nonatomic) IBOutlet UIView *topLineContentV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *botVHeiCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *botVLefCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *botVRigCon;
@property (weak, nonatomic) IBOutlet UIView *botLineV;
@property (weak, nonatomic) IBOutlet UIView *botLineContentV;
@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) CAShapeLayer *angelLayer;

@end

@implementation PriceTipV

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.contentV.layer.borderColor = kHexColor(kTintColorHex, 1).CGColor;
//    self.contentV.layer.borderWidth = 0.5;
    self.contentV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.contentV.layer.cornerRadius = 2;
    self.contentV.layer.masksToBounds = true;
    self.titleLab.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    
    self.lineLayer = [CAShapeLayer layer];
    self.lineLayer.strokeColor = [[UIColor clearColor] CGColor];
    self.lineLayer.fillColor = [UIColor clearColor].CGColor;
    self.lineLayer.lineWidth = 0.5;
    self.lineLayer.lineCap = kCALineCapRound;
    self.lineLayer.lineJoin = kCALineJoinRound;
    
    self.angelLayer = [CAShapeLayer layer];
    self.angelLayer.strokeColor = [UIColor clearColor].CGColor;
    self.angelLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor;
    self.angelLayer.lineWidth = 0.5;
    self.angelLayer.lineCap = kCALineCapRound;
    self.angelLayer.lineJoin = kCALineJoinRound;
}

- (void)setLabWithTitle:(NSString *)title subTitle:(NSString *)subTitle isTop:(BOOL)isTop isLeft:(BOOL)isLeft x:(CGFloat)x width:(CGFloat)width {
    self.titleLab.text = title;
    self.subTitleLab.text = subTitle;
    self.contentV.layer.cornerRadius = 4;
    if (isTop) {
//        self.topLineContentV.backgroundColor = kHexColor(kTintColorHex, 1);
//        self.botLineContentV.backgroundColor = [UIColor whiteColor];
        self.topVHeiCon.constant = 0.5;
        self.botVHeiCon.constant = 5;
    } else {
//        self.botLineContentV.backgroundColor = kHexColor(kTintColorHex, 1);
//        self.topLineContentV.backgroundColor = [UIColor whiteColor];
        self.botVHeiCon.constant = 0.5;
        self.topVHeiCon.constant = 5;
    }
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    UIBezierPath *angelPath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(5, isTop ? 0.25 : 4.5)];
    if (isLeft) {
        [linePath addLineToPoint:CGPointMake((x > 10 ? x : 10) - 5, isTop ? 0.25 : 4.5)];
        [linePath addLineToPoint:CGPointMake(x, isTop ? 4.5 : 0.25)];
        [linePath addLineToPoint:CGPointMake(x + 5, isTop ? 0.25 : 4.5)];
        [linePath addLineToPoint:CGPointMake(width - 5, isTop ? 0.25 : 4.5)];
        [angelPath moveToPoint:CGPointMake((x > 10 ? x : 10) - 5, isTop ? 0.25 : 4.5)];
        [angelPath addLineToPoint:CGPointMake(x, isTop ? 4.5 : 0.25)];
        [angelPath addLineToPoint:CGPointMake(x + 5, isTop ? 0.25 : 4.5)];
        [angelPath closePath];
    } else {
        [linePath addLineToPoint:CGPointMake(x - 5, isTop ? 0.25 : 4.75)];
        [linePath addLineToPoint:CGPointMake(x, isTop ? 4.75 : 0.25)];
        [linePath addLineToPoint:CGPointMake(width - x > 10 ? x + 5 : width - 5, isTop ? 0.25 : 4.75)];
        [linePath addLineToPoint:CGPointMake(width - 5, isTop ? 0.25 : 4.75)];
        
        [angelPath moveToPoint:CGPointMake(x - 5, isTop ? 0.25 : 4.75)];
        [angelPath addLineToPoint:CGPointMake(x, isTop ? 4.75 : 0.25)];
        [angelPath addLineToPoint:CGPointMake(width - x > 10 ? x + 5 : width - 5, isTop ? 0.25 : 4.75)];
        [angelPath closePath];
    }
    self.lineLayer.path = linePath.CGPath;
    if ([self.lineLayer superlayer]) {
        [self.lineLayer removeFromSuperlayer];
    }
    self.angelLayer.path = angelPath.CGPath;
    if (isTop) {
        [self.botLineV.layer addSublayer:self.angelLayer];
        [self.botLineV.layer addSublayer:self.lineLayer];
    } else {
        [self.topLineV.layer addSublayer:self.angelLayer];
        [self.topLineV.layer addSublayer:self.lineLayer];
    }
    self.alpha = 0.9;
    [self layoutIfNeeded];
}
@end
