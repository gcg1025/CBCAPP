//
//  PriceClassV.h
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/24.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PriceClassV : UIView

@property (nonatomic, strong) NSArray<PriceClassM *> *dataAry;
@property (nonatomic, copy) void (^closeBlock)(void);
@property (nonatomic, copy) void (^confirmBlock)(void);

- (void)showView;

@end

NS_ASSUME_NONNULL_END
