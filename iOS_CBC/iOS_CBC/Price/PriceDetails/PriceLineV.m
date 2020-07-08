//
//  PriceLineV.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/6/21.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "PriceLineV.h"
#import "PriceTipV.h"

@interface PriceLineV ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lefCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rigCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *botCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentVRigCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yLabVWidCon;

@property (weak, nonatomic) IBOutlet UIView *requestV;
@property (weak, nonatomic) IBOutlet UIView *xLabV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navVTopCon;

@property (weak, nonatomic) IBOutlet UIView *navV;
@property (weak, nonatomic) IBOutlet UIView *btnV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *unitLab;

@property (weak, nonatomic) IBOutlet UILabel *yLab1;
@property (weak, nonatomic) IBOutlet UILabel *yLab2;
@property (weak, nonatomic) IBOutlet UILabel *yLab3;
@property (weak, nonatomic) IBOutlet UILabel *yLab4;


@property (weak, nonatomic) IBOutlet UILabel *xLab1;
@property (weak, nonatomic) IBOutlet UILabel *xLab2;
@property (weak, nonatomic) IBOutlet UILabel *xLab3;
@property (weak, nonatomic) IBOutlet UILabel *xLab4;

@property (nonatomic, assign) CGFloat yLabVWid;

@property (weak, nonatomic) IBOutlet UIView *lineV;
@property (nonatomic, assign) CGFloat lineVWid;
@property (nonatomic, assign) CGFloat lineVHei;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, assign) CGFloat vWid;
@property (nonatomic, assign) CGFloat vHei;

@property (nonatomic, strong) NSMutableArray<NSValue *> *tempPointsAry;
@property (nonatomic, strong) NSMutableArray<NSValue *> *destPointsAry;
@property (nonatomic, strong) NSMutableArray<NSValue *> *oriPointsAry;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timerCount;
@property (nonatomic, assign) NSInteger tipIndex;
@property (weak, nonatomic) IBOutlet UIView *pointV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointVLefCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointVTopCon;

@property (nonatomic, strong) PriceTipV *priceTipV;
@property (weak, nonatomic) IBOutlet UIView *tipBackgroundV;


@end

@implementation PriceLineV

- (PriceTipV *)priceTipV {
    if (!_priceTipV) {
        _priceTipV = [[NSBundle mainBundle] loadNibNamed:@"PriceTipV" owner:nil options:nil].firstObject;
        _priceTipV.alpha = 0;
        [self.tipBackgroundV addSubview:_priceTipV];
    }
    return _priceTipV;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setViews];
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.lineWidth = 2;
    self.shapeLayer.strokeColor = kHexColor(kTintColorHex, 1).CGColor;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.lineJoin = kCALineJoinRound;
    self.shapeLayer.lineCap = kCALineCapRound;
}


- (void)setViews {
    self.pointV.alpha = 0;
    [self.priceTipV removeFromSuperview];
    self.priceTipV = nil;
    [self transWidHei];
    if (self.isFull) {
        self.lefCon.constant = kStatusH + 20;
        self.contentVRigCon.constant = 100;
        NSString *version= [UIDevice currentDevice].systemVersion;
        if (version.doubleValue < 11) {
            self.topCon.constant = 64;
            self.navVTopCon.constant = kStatusH / 2;
            self.rigCon.constant = kScreenW - kScreenH + 20;
            self.botCon.constant = kScreenH - kScreenW + 20;
        } else {
            self.topCon.constant = 44;
            self.navVTopCon.constant = kBottomH > 0 ? -(kStatusH / 2) : kStatusH / 2;
            self.rigCon.constant = 20;
            self.botCon.constant = kBottomH > 0 ? 0 : 20;
        }
        self.navV.alpha = 1;
        self.btnV.alpha = 1;
    } else {
//        NSString *version= [UIDevice currentDevice].systemVersion;
//        if (version.doubleValue < 11) {
//            self.topCon.constant = 20;
//        } else {
            self.topCon.constant = 0;
//        }
        self.lefCon.constant = 16;
        self.rigCon.constant = 40;
        self.contentVRigCon.constant = 0;
        self.botCon.constant = 0;
        self.navV.alpha = 0;
        self.btnV.alpha = 0;
    }
    [self layoutIfNeeded];
    [self setCurrentLineIndex:self.currentLineIndex];
    if (self.requestV.alpha == 0) {
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        NSInteger count = self.destPointsAry.count;
        NSInteger dataCount = self.model.yDataAry.count;
        [self.destPointsAry removeAllObjects];
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        for (NSInteger i = 0; i < count; i ++) {
            CGPoint desPoint;
            if (i < dataCount) {
                desPoint = CGPointMake(self.lineVWid / dataCount * (i + 0.5), (1 - self.model.yScaleAry[i].floatValue) * self.lineVHei);
                if (i == 0) {
                    [bezierPath moveToPoint:desPoint];
                } else {
                    [bezierPath addLineToPoint:desPoint];
                }
            } else {
                desPoint = CGPointMake(self.lineVWid + 10, 0.5 * self.lineVHei);
            }
            [self.destPointsAry addObject:[NSValue valueWithCGPoint:desPoint]];
        }
        [self.tempPointsAry removeAllObjects];
        [self.tempPointsAry addObjectsFromArray:self.destPointsAry];
        self.shapeLayer.path = bezierPath.CGPath;
    }
}

- (void)setModel:(PriceDetailsLineM *)model {
    _model = model;
    self.unitLab.text = [NSString stringWithFormat:@"单位:%@", self.tipUnitStr];
    self.pointV.alpha = 0;
    self.priceTipV.alpha = 0;
    self.yLab1.text = [Tool transFloat:model.yData1 digits:2 usesGroupingSeparator:true];
    self.yLab2.text = [Tool transFloat:model.yData2 digits:2 usesGroupingSeparator:true];
    self.yLab3.text = [Tool transFloat:model.yData3 digits:2 usesGroupingSeparator:true];
    self.yLab4.text = [Tool transFloat:model.yData4 digits:2 usesGroupingSeparator:true];
    if (self.yLabVWid == 0) {
        CGFloat max = 0;
        max = fmax(max, [Tool widthForString:self.yLab1.text font:[UIFont systemFontOfSize:12]]);
        max = fmax(max, [Tool widthForString:self.yLab2.text font:[UIFont systemFontOfSize:12]]);
        max = fmax(max, [Tool widthForString:self.yLab3.text font:[UIFont systemFontOfSize:12]]);
        max = fmax(max, [Tool widthForString:self.yLab4.text font:[UIFont systemFontOfSize:12]]);
        self.yLabVWidCon.constant = max + 20;
        self.yLabVWid = max + 20;
        [self layoutIfNeeded];
    }
    
    self.xLab1.text = model.xData1;
    self.xLab2.text = model.xData2;
    self.xLab3.text = model.xData3;
    self.xLab4.text = model.xData4;
    self.requestV.alpha = 0;
    self.xLabV.alpha = 1;
    
    [self transWidHei];

    NSDate *currentdata = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:-5];
    NSInteger count = [calendar components:NSCalendarUnitDay fromDate:[calendar dateByAddingComponents:components toDate:currentdata options:kNilOptions] toDate:currentdata options:kNilOptions].day;
    NSInteger dataCount = model.yDataAry.count;
    if (self.shapeLayer.superlayer) {
        [self.oriPointsAry removeAllObjects];
        [self.oriPointsAry addObjectsFromArray:self.tempPointsAry];
        [self.destPointsAry removeAllObjects];
        for (NSInteger i = 0; i < count; i ++) {
            CGPoint desPoint;
            if (i < dataCount) {
                desPoint = CGPointMake(self.lineVWid / dataCount * (i + 0.5), (1 - model.yScaleAry[i].floatValue) * self.lineVHei);
            } else {
                desPoint = CGPointMake(self.lineVWid + 10, 0.5 * self.lineVHei);
            }
            [self.destPointsAry addObject:[NSValue valueWithCGPoint:desPoint]];
        }
    } else {
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(0, self.lineVHei / 2)];
        [bezierPath addLineToPoint:CGPointMake(self.lineVWid, self.lineVHei / 2)];
        self.shapeLayer.path = bezierPath.CGPath;
        [self.lineV.layer addSublayer:self.shapeLayer];
        self.oriPointsAry = @[].mutableCopy;
        self.destPointsAry = @[].mutableCopy;
        self.tempPointsAry = @[].mutableCopy;
        for (NSInteger i = 0; i < count; i ++) {
            CGPoint oriPoint;
            CGPoint desPoint;
            if (i < dataCount) {
                oriPoint = CGPointMake(self.lineVWid / dataCount * (i + 0.5), 0.5 * self.lineVHei);
                desPoint = CGPointMake(self.lineVWid / dataCount * (i + 0.5), (1 - model.yScaleAry[i].floatValue) * self.lineVHei);
            } else {
                oriPoint = CGPointMake(self.lineVWid + 10, 0.5 * self.lineVHei);
                desPoint = CGPointMake(self.lineVWid + 10, 0.5 * self.lineVHei);
            }
            [self.oriPointsAry addObject:[NSValue valueWithCGPoint:oriPoint]];
            [self.destPointsAry addObject:[NSValue valueWithCGPoint:desPoint]];
        }
    }
    self.timerCount = 0;
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(lineAnimation) userInfo:nil repeats:true];
    }
    self.tipIndex = -1;
}

- (void)transWidHei {
    CGFloat width = 0;
    CGFloat height = 0;
    
    if (self.isFull) {
        width = kScreenH - kStatusH - self.yLabVWid - 140;
        height = kScreenW - kStatusH - 94 - kBottomH;
        NSString *version= [UIDevice currentDevice].systemVersion;
        if (version.doubleValue < 11) {
            height -= 20;
        }
    } else {
        height = 120;
        width = kScreenW - 56 - self.yLabVWid;
    }
    self.lineVWid = width;
    self.lineVHei = height;
}

- (void)lineAnimation {
    self.timerCount ++;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < self.oriPointsAry.count; i ++) {
        CGPoint desPoint = self.destPointsAry[i].CGPointValue;
        CGPoint oriPoint = self.oriPointsAry[i].CGPointValue;
        self.tempPointsAry[i] = [NSValue valueWithCGPoint:CGPointMake((desPoint.x - oriPoint.x) / 20 * self.timerCount + oriPoint.x, (desPoint.y - oriPoint.y) / 20 * self.timerCount + oriPoint.y)];
        if (i == 0) {
            [bezierPath moveToPoint:self.tempPointsAry[i].CGPointValue];
        } else {
            [bezierPath addLineToPoint:self.tempPointsAry[i].CGPointValue];
        }
    }
    self.shapeLayer.path = bezierPath.CGPath;
    if (self.timerCount == 20) {
        [self.timer invalidate];
        self.timer = nil;
        bezierPath = [UIBezierPath bezierPath];
        for (NSInteger i = 0; i < self.oriPointsAry.count; i ++) {
            if (i < self.model.yDataAry.count) {
                CGPoint desPoint = self.destPointsAry[i].CGPointValue;
                if (i == 0) {
                    [bezierPath moveToPoint:desPoint];
                } else {
                    [bezierPath addLineToPoint:desPoint];
                }
            } else {
                break;
            }
        }
        self.shapeLayer.path = bezierPath.CGPath;
    }
}

- (void)setType:(PriceLineVType)type {
    switch (type) {
        case PriceLineVTypeRequest:
            self.requestV.alpha = 1;
            self.xLabV.alpha = 0;
            self.pointV.alpha = 0;
            break;
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [touches.anyObject locationInView:self.lineV];
    if (point.x > 0 && point.y > 0 && point.x < self.lineVWid && point.y < self.lineVHei) {
        [self showTipVWithX:point.x];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [touches.anyObject locationInView:self.lineV];
    if (point.x > 0 && point.y > 0 && point.x < self.lineVWid && point.y < self.lineVHei) {
        [self showTipVWithX:point.x];
    }
}

- (void)showTipVWithX:(CGFloat)x {
    NSInteger index = @(floor(self.model.yDataAry.count * x / self.lineVWid)).integerValue;
    if (self.tipIndex != index) {
        self.tipIndex = index;
        CGPoint point = self.destPointsAry[self.tipIndex].CGPointValue;
        self.pointVLefCon.constant = point.x - 5;
        self.pointVTopCon.constant = point.y - 5;
        [self layoutIfNeeded];
        self.pointV.alpha = 1;
        if (self.model.yDataAry.count > self.tipIndex) {
            NSString *subTitle = [NSString stringWithFormat:@"%@:%@(%@)", self.model.xDataAry[self.tipIndex], [Tool transFloat:self.model.yDataAry[self.tipIndex] digits:2 usesGroupingSeparator:true], self.tipUnitStr];
            CGFloat frameWid = [Tool widthForString:subTitle font:[UIFont systemFontOfSize:12]] + 20;
            CGFloat frameHei = [Tool heightForString:self.tipTitle font:[UIFont systemFontOfSize:12]] * 2 + 17.5;
            CGFloat pointX = point.x;
            CGFloat pointY = point.y;
            CGFloat frameX, frameY;
            if (pointX > self.lineVWid - frameWid / 2) {
                frameX = self.lineVWid - frameWid;
                if (frameX < 0) {
                    frameX = 0;
                }
            } else if (pointX < frameWid / 2) {
                frameX = 0;
            } else {
                frameX = pointX - frameWid / 2;
            }
            BOOL isTop = false;
            if (pointY >= frameHei + 10) {
                frameY = pointY - frameHei - 10;
                isTop = true;
            } else {
                frameY = pointY + 10;
                isTop = false;
            }
            self.priceTipV.alpha = 1;
            self.priceTipV.frame = CGRectMake(frameX + self.yLabVWid, frameY + 20, frameWid, frameHei);
            [self.priceTipV setLabWithTitle:self.tipTitle subTitle:subTitle isTop:isTop isLeft:pointX < self.lineVWid / 2 x:pointX - frameX width:frameWid];
        }
    }
}

- (void)setIsFull:(BOOL)isFull {
    _isFull = isFull;
    [self setViews];
}

- (IBAction)backAct:(id)sender {
    self.backBlock();
}

- (IBAction)selectAct:(UIButton *)sender {
    self.selectBlock(sender.tag - 10);
}

- (void)setCurrentLineIndex:(NSInteger)currentLineIndex {
    _currentLineIndex = currentLineIndex;
    for (NSInteger i = 30010; i < 30015; i ++) {
        UIButton *btn = [self viewWithTag:i];
        btn.backgroundColor = kHexColor(i - 30010 == currentLineIndex ? @"FF9018" : @"E2EAF8", 1);
        [btn setTitleColor:kHexColor(i - 30010 == currentLineIndex ? @"FFFFFF" : @"333333", 1) forState:UIControlStateNormal];
    }
}

- (IBAction)reloadAct:(id)sender {
    self.reloadBlock();
}

- (void)setTitle:(NSString *)title {
    self.titleLab.text = title;
}

@end
