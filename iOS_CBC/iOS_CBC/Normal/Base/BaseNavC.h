//
//  BaseNavC.h
//  SDB_Optimize
//
//  Created by SDB_Mac on 2020/1/7.
//  Copyright © 2020 Regent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseNavC : UINavigationController

@property (assign, nonatomic) BOOL shouldAutoRatate;
@property (assign, nonatomic) UIInterfaceOrientationMask interfaceOrientationMask;
@property (assign, nonatomic) UIInterfaceOrientation interfaceOrientation;

@end

NS_ASSUME_NONNULL_END
