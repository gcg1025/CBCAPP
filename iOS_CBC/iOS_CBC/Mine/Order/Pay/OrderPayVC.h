//
//  OrderPayVC.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/21.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderPayVC : BaseVC

@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, strong) NSString *orderNum;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *payMoney;
@property (nonatomic, strong) NSString *systemDate;

@end

NS_ASSUME_NONNULL_END
