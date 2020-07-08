//
//  NewsClassV.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/29.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "NewsClassV.h"
#import "NewsClassTitleV.h"
#import "NewsClassContentV.h"

@interface NewsClassV ()

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

@implementation NewsClassV

- (NSMutableArray *)viewAry {
    if (!_viewAry) {
        _viewAry = @[].mutableCopy;
    }
    return _viewAry;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
}

- (void)setType:(NewsClassType)type {
    _type = type;
    self.backgroundVTopCon.constant = kScreenH;
    self.backgroundVBotCon.constant = type == NewsClassTypeNormal ? -(kScreenH - kBottomVH) : -(kScreenH - kBottomH);
}

- (void)setDataAry:(NSArray<NewsClassM *> *)dataAry {
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
            NewsClassTitleV *newsClassTitleV = [[NewsClassTitleV alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 200)];
            newsClassTitleV.type = self.type;
            newsClassTitleV.model = dataAry[i];
            newsClassTitleV.closeBlock = ^{
                [weakSelf hideViewCompletion:^(BOOL finished) {
                    if (weakSelf.closeBlock) {
                        weakSelf.closeBlock();
                    }
                }];
            };
            kWeakSelf
            newsClassTitleV.deleteBlock = ^(NewsClassM * _Nonnull model) {
                for (NSInteger i = 1; i < self.dataAry.count; i ++) {
                    if ([weakSelf.dataAry[i].subClass containsObject:model]) {
                        NewsClassContentV *view = weakSelf.viewAry[i];
                        [view reloadItemsAtIndex:[weakSelf.dataAry[i].subClass indexOfObject:model]];
                    }
                }
                [weakSelf resetViews];
            };
            newsClassTitleV.confirmBlock = ^{
                [weakSelf hideViewCompletion:^(BOOL finished) {
                    if (weakSelf.confirmBlock) {
                        weakSelf.confirmBlock();
                    }
                }];
            };
            [self.titleV addSubview:newsClassTitleV];
            [self.viewAry addObject:newsClassTitleV];
        } else {
            NewsClassContentV *newsClassContentV = [[NewsClassContentV alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
            newsClassContentV.frame = CGRectMake(0, hei, kScreenW, (dataAry[i].subClass.count / 4 + (dataAry[i].subClass.count % 4 > 0 ? 1 : 0)) * 56 + 47);
            hei += (dataAry[i].subClass.count / 4 + (dataAry[i].subClass.count % 4 > 0 ? 1 : 0)) * 56 + 47;
            [self.contentV addSubview:newsClassContentV];
            newsClassContentV.model = dataAry[i];
            newsClassContentV.selectModel = dataAry[0];
            newsClassContentV.selectBlock = ^(NewsClassM * _Nonnull model) {
                NSMutableArray *ary = weakSelf.dataAry[0].subClass.mutableCopy;
                if (![ary containsObject:model]) {
                    [ary addObject:model];
                }
                weakSelf.dataAry[0].subClass = ary.copy;
                NewsClassTitleV *view = weakSelf.viewAry[0];
                [view insertWithIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.dataAry[0].subClass.count - 1 inSection:0]].mutableCopy];
                [weakSelf resetViews];
            };
            newsClassContentV.allBlock = ^(NewsClassM * _Nonnull model, BOOL isSelect) {
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
                        NewsClassM *selectModel = weakSelf.dataAry[0].subClass[i];
                        if (ary.count > 1) {
                           if ([model.subClass containsObject:selectModel]) {
                               [ary removeObject:selectModel];
                               [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                            }
                        }
                    }
                }
                weakSelf.dataAry[0].subClass = ary.copy;
                NewsClassTitleV *view = weakSelf.viewAry[0];
                if (isSelect) {
                    [view insertWithIndexPaths:indexPaths];
                } else {
                    [view deleteWithIndexPaths:indexPaths];
                }
                [weakSelf resetViews];
            };
            [self.viewAry addObject:newsClassContentV];
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
            ((NewsClassTitleV *)weakSelf.viewAry[0]).frame = CGRectMake(0, 0, kScreenW, weakSelf.currentTitleVHei);
            [weakSelf layoutIfNeeded];
        }];
        [self layoutIfNeeded];
    }
}

- (void)showView {
    self.backgroundVTopCon.constant = kTopVH;
    self.backgroundVBotCon.constant = self.type == NewsClassTypeNormal ? kBottomVH : 0;
    kWeakSelf
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 1;
        [weakSelf layoutIfNeeded];
    }];
}

- (void)hideViewCompletion:(void (^ __nullable)(BOOL finished))completion {
    self.backgroundVTopCon.constant = kScreenH;
    self.backgroundVBotCon.constant = (NewsClassTypeNormal ? kBottomVH : 0) + kTopVH - kScreenH;
    kWeakSelf
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 0;
        [weakSelf layoutIfNeeded];
    } completion:completion];
}
@end
