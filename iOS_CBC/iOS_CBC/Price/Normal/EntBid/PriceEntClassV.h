//
//  PriceEntClassV.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/22.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PriceEntClassV : UIView

@property (nonatomic, strong) NSMutableArray<PriceModelM *> *dataAry;
@property (nonatomic, copy) void (^selectBlock)(void);

- (void)showView;

@end

NS_ASSUME_NONNULL_END
