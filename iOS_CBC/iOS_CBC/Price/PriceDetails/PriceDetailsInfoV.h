//
//  PriceDetailsInfoV.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/8.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PriceDetailsInfoV : UIView

@property (nonatomic, strong) PriceDetailsM *model;

- (void)showView;

@end

NS_ASSUME_NONNULL_END
