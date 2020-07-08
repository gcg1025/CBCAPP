//
//  OrderPayResultV.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/25.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderPayResultV : UIView

@property (nonatomic, copy) void (^closeBlock)(void);

- (void)showView;

@end

NS_ASSUME_NONNULL_END
