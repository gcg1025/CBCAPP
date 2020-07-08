//
//  BasePageV.h
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/27.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DataType) {
    DataTypePrice,
    DataTypeNews
};

@interface BasePageV : UIView

@property (nonatomic, assign) DataType dataType;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSMutableArray<PageDataM *> *dataAry;
@property (nonatomic, copy) void (^refreshBlock)(NSInteger ID, PageDataM *model, BOOL isReload, PriceContentClassM *__nullable classM);
@property (nonatomic, copy) void (^scrollBlock)(NSInteger index);
@property (nonatomic, copy) void (^selectBlock)(PageDataM *model);
@property (nonatomic, copy) void (^newsSelectBlock)(NewsM *model, BOOL isBid);
@property (nonatomic, copy) void (^detailsBlock)(PriceDetailsM *model);

- (void)setViewWithModel:(PageDataM *)model;
- (void)scrollToIndex:(NSInteger)index;

- (void)entReolad;

@end

NS_ASSUME_NONNULL_END
