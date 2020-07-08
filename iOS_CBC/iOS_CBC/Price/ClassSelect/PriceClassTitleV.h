//
//  PriceClassTitleV.h
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/26.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PriceClassTitleV : UIView

@property (nonatomic, strong) PriceClassM *model;
@property (nonatomic, copy) void (^closeBlock)(void);
@property (nonatomic, copy) void (^deleteBlock)(PriceClassM *model);
@property (nonatomic, copy) void (^confirmBlock)(void);

- (void)insertWithIndexPaths:(NSMutableArray<NSIndexPath *> *)indexPaths;
- (void)deleteWithIndexPaths:(NSMutableArray<NSIndexPath *> *)indexPaths;

@end

NS_ASSUME_NONNULL_END
