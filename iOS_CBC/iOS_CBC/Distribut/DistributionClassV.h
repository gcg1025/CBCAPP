//
//  DistributionClassV.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/25.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DistributionClassType) {
    DistributionClassTypeClass,
    DistributionClassTypeSubClass
};

NS_ASSUME_NONNULL_BEGIN


@interface DistributionClassV : UIView

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) DistributionClassType type;
@property (nonatomic, copy) void (^selectBlock)(DistributionClassType type, NSInteger ID, NSString *className, NSString *subClassName);

- (void)showWithType:(DistributionClassType)type;

@end

NS_ASSUME_NONNULL_END
