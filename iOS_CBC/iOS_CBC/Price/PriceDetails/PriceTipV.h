//
//  PriceTipV.h
//  SDB_Optimize
//
//  Created by SDB_Mac on 2020/6/16.
//  Copyright © 2020 Regent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PriceTipV : UIView

- (void)setLabWithTitle:(NSString *)title subTitle:(NSString *)subTitle isTop:(BOOL)isTop isLeft:(BOOL)isLeft x:(CGFloat)x width:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
