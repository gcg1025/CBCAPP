//
//  FOOPriceTableCell.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/21.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FOOPriceTableCell : UITableViewCell

@property (nonatomic, assign) BOOL isOAll;
@property (nonatomic, strong) PriceFOM *model;
@property (nonatomic, copy) void (^selectBlock)(PriceFOM *model);

@end

NS_ASSUME_NONNULL_END
