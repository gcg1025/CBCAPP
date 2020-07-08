//
//  OrderPayFunctionTableCell.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/23.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger, OrderPayFunctionType) {
    OrderPayFunctionTypeWechat,
    OrderPayFunctionTypeAli,
    OrderPayFunctionTypeBank
};

NS_ASSUME_NONNULL_BEGIN

@interface OrderPayFunctionTableCell : UITableViewCell

@property (nonatomic, assign) BOOL isChoice;
@property (nonatomic, assign) OrderPayFunctionType type;
@property (nonatomic, strong) OrderInfoM *model;

@end

NS_ASSUME_NONNULL_END
