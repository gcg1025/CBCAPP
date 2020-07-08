//
//  StoPriceTitleTableCell.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/19.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoPriceTitleTableCell : UITableViewCell

@property (nonatomic, strong) PriceContentClassM *model;
@property (nonatomic, copy) void (^selectBlock)(PriceContentClassM *classM);

@end

NS_ASSUME_NONNULL_END
