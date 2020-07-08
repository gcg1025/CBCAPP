//
//  OrderPayTimeTableCell.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/23.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderPayTimeTableCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void (^selectBlock)(NSInteger index, NSString *timeStr);
@property (nonatomic, strong) OrderInfoM *model;

@end

NS_ASSUME_NONNULL_END
