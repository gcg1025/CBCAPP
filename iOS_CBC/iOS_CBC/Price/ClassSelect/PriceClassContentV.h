//
//  PriceClassContentV.h
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/26.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PriceClassContentV : UIView

@property (nonatomic, strong) PriceClassM *model;
@property (nonatomic, strong) PriceClassM *selectModel;
@property (nonatomic, copy) void (^selectBlock)(PriceClassM *model);
@property (nonatomic, copy) void (^allBlock)(PriceClassM *model, BOOL isSelect);

- (void)reloadItemsAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
