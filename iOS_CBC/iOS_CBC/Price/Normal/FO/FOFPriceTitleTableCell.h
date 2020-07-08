//
//  FOFPriceTitleTableCell.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/21.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FOFPriceTitleTableCell : UITableViewCell

@property (nonatomic, strong) PriceFOClassM *model;
@property (nonatomic, copy) void (^selectBlock)(PriceFOClassM *classM);

@end

NS_ASSUME_NONNULL_END
