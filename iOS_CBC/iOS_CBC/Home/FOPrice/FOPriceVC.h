//
//  FOPriceVC.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/1.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "BaseVC.h"

typedef NS_ENUM(NSInteger, FOType) {
    FOTypeFutures,
    FOTypeOrgnization
};

NS_ASSUME_NONNULL_BEGIN

@interface FOPriceVC : BaseVC

@property (nonatomic, assign) FOType type;

@end

NS_ASSUME_NONNULL_END
