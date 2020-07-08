//
//  FOFPriceTableCell.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/21.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FuturePriceType) {
    FuturePriceTypeNo = 0,
    FuturePriceTypeNormal = 1,
    FuturePriceTypeLEM = 2,
    FuturePriceTypeTOCOM = 3
};

NS_ASSUME_NONNULL_BEGIN

@interface FOFPriceTableCell : UITableViewCell

@property (nonatomic, assign) FuturePriceType type;
@property (nonatomic, strong) PriceFOM *model;
@property (nonatomic, copy) void (^selectBlock)(PriceFOM *model);

@end

NS_ASSUME_NONNULL_END
