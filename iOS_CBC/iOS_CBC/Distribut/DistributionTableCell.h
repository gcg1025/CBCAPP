//
//  DistributionTableCell.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/25.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DistributionTableCell : UITableViewCell

@property (nonatomic, strong) DistributionM *model;
@property (nonatomic, copy) void (^selectBlock)(DistributionM *model);
@property (nonatomic, copy) void (^modifyBlock)(DistributionM *model);

@end

NS_ASSUME_NONNULL_END
