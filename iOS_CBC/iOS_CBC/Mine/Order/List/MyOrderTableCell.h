//
//  MyOrderTableCell.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/24.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderTableCell : UITableViewCell

@property (nonatomic, copy) void (^selectBlock)(OrderInfoM *model);
@property (nonatomic, strong) OrderInfoM *model;

@end

NS_ASSUME_NONNULL_END
