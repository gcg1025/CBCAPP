//
//  LoginV.h
//  iOS_CBC
//
//  Created by SDB_Mac on 2020/2/12.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginV : UIView

@property (nonatomic, copy) void(^loginBlock)(void);

@end

NS_ASSUME_NONNULL_END
