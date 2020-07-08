//
//  FOPriceClassV.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/8.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FOPriceClassV : UIView

@property (nonatomic, strong) NSMutableArray<FOPriceM *> *dataAry;
@property (nonatomic, copy) void (^selectBlock)(NSInteger index);

- (void)showView;

@end

NS_ASSUME_NONNULL_END
