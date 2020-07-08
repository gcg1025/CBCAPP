//
//  PriceClassV.m
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/24.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import "PriceClassV.h"
#import "PriceClassTitleV.h"
#import "PriceClassContentV.h"

@interface PriceClassV ()

@property (weak, nonatomic) IBOutlet UIView *backgroundV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundVTopCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundVBotCon;
@property (weak, nonatomic) IBOutlet UIView *titleV;
@property (weak, nonatomic) IBOutlet UIView *contentV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleVHeiCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentBackgroundVHeiCon;

@property (nonatomic, assign) CGFloat currentTitleVHei;
@property (nonatomic, assign) CGFloat currentContentVHei;
@property (nonatomic, strong) NSMutableArray<id> *viewAry;

@end

@implementation PriceClassV

- (NSMutableArray *)viewAry {
    if (!_viewAry) {
        _viewAry = @[].mutableCopy;
    }
    return _viewAry;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.backgroundVTopCon.constant = kScreenH;
    self.backgroundVBotCon.constant = -(kScreenH - kBottomVH);
}

- (void)setDataAry:(NSArray<PriceClassM *> *)dataAry {
    _dataAry = dataAry;
    self.currentTitleVHei = 0;
    for (UIView *view in self.viewAry) {
        [view removeFromSuperview];
    }
    self.viewAry = @[].mutableCopy;
    CGFloat hei = 0;
    kWeakSelf
    for (NSInteger i = 0; i < dataAry.count; i ++) {
        if (i == 0) {
            PriceClassTitleV *priceClassTitleV = [[PriceClassTitleV alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 200)];
            priceClassTitleV.model = dataAry[i];
            priceClassTitleV.closeBlock = ^{
                [weakSelf hideViewCompletion:^(BOOL finished) {
                    if (weakSelf.closeBlock) {
                        weakSelf.closeBlock();
                    }
                }];
            };
            kWeakSelf
            priceClassTitleV.deleteBlock = ^(PriceClassM * _Nonnull model) {
                for (NSInteger i = 1; i < self.dataAry.count; i ++) {
                    if ([weakSelf.dataAry[i].subClass containsObject:model]) {
                        PriceClassContentV *view = weakSelf.viewAry[i];
                        [view reloadItemsAtIndex:[weakSelf.dataAry[i].subClass indexOfObject:model]];
                    }
                }
                [weakSelf resetViews];
            };
            priceClassTitleV.confirmBlock = ^{
                [weakSelf hideViewCompletion:^(BOOL finished) {
                    if (weakSelf.confirmBlock) {
                        weakSelf.confirmBlock();
                    }
                }];
            };
            [self.titleV addSubview:priceClassTitleV];
            [self.viewAry addObject:priceClassTitleV];
        } else {
            PriceClassContentV *priceClassContentV = [[PriceClassContentV alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
            priceClassContentV.frame = CGRectMake(0, hei, kScreenW, (dataAry[i].subClass.count / 4 + (dataAry[i].subClass.count % 4 > 0 ? 1 : 0)) * 56 + 47);
            hei += (dataAry[i].subClass.count / 4 + (dataAry[i].subClass.count % 4 > 0 ? 1 : 0)) * 56 + 47;
            [self.contentV addSubview:priceClassContentV];
            priceClassContentV.model = dataAry[i];
            priceClassContentV.selectModel = dataAry[0];
            priceClassContentV.selectBlock = ^(PriceClassM * _Nonnull model) {
                NSMutableArray *ary = weakSelf.dataAry[0].subClass.mutableCopy;
                if (![ary containsObject:model]) {
                    [ary addObject:model];
                }
                weakSelf.dataAry[0].subClass = ary.copy;
                PriceClassTitleV *view = weakSelf.viewAry[0];
                [view insertWithIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.dataAry[0].subClass.count - 1 inSection:0]].mutableCopy];
                [weakSelf resetViews];
            };
            priceClassContentV.allBlock = ^(PriceClassM * _Nonnull model, BOOL isSelect) {
                NSMutableArray *ary = weakSelf.dataAry[0].subClass.mutableCopy;
                NSMutableArray *indexPaths = @[].mutableCopy;
                if (isSelect) {
                    for (PriceClassM *subModel in model.subClass) {
                        if (![ary containsObject:subModel]) {
                            [ary addObject:subModel];
                            [indexPaths addObject:[NSIndexPath indexPathForRow:[ary indexOfObject:subModel] inSection:0]];
                        }
                    }
                } else {
                    for (NSInteger i = weakSelf.dataAry[0].subClass.count - 1; i >= 0; i --) {
                        PriceClassM *selectModel = weakSelf.dataAry[0].subClass[i];
                        if (ary.count > 1) {
                           if ([model.subClass containsObject:selectModel]) {
                               [ary removeObject:selectModel];
                               [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                            }
                        }
                    }
                }
                weakSelf.dataAry[0].subClass = ary.copy;
                PriceClassTitleV *view = weakSelf.viewAry[0];
                if (isSelect) {
                    [view insertWithIndexPaths:indexPaths];
                } else {
                    [view deleteWithIndexPaths:indexPaths];
                }
                [weakSelf resetViews];
            };
            [self.viewAry addObject:priceClassContentV];
        }
    }
    self.currentContentVHei = hei;
    [self resetViews];
}

- (void)resetViews {
    if (self.currentTitleVHei != (self.dataAry[0].subClass.count / 4 + (self.dataAry[0].subClass.count % 4 > 0 ? 1 : 0)) * 56 + 168) {
        self.currentTitleVHei = (self.dataAry[0].subClass.count / 4 + (self.dataAry[0].subClass.count % 4 > 0 ? 1 : 0)) * 56 + 168;
        self.titleVHeiCon.constant = self.currentTitleVHei;
        self.contentBackgroundVHeiCon.constant = self.currentTitleVHei + self.currentContentVHei;
        kWeakSelf
        [UIView animateWithDuration:0.3 animations:^{
            ((PriceClassTitleV *)weakSelf.viewAry[0]).frame = CGRectMake(0, 0, kScreenW, weakSelf.currentTitleVHei);
            [weakSelf layoutIfNeeded];
        }];
        [self layoutIfNeeded];
    }
}

- (void)showView {
    self.backgroundVTopCon.constant = kTopVH;
    self.backgroundVBotCon.constant = kBottomVH;
    kWeakSelf
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 1;
        [weakSelf layoutIfNeeded];
    }];
}

- (void)hideViewCompletion:(void (^ __nullable)(BOOL finished))completion {
    self.backgroundVTopCon.constant = kScreenH;
    self.backgroundVBotCon.constant = kBottomVH + kTopVH - kScreenH;
    kWeakSelf
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 0;
        [weakSelf layoutIfNeeded];
    } completion:completion];
}

@end
