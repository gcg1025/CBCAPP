//
//  NewsClassV.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/29.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsClassV : UIView

@property (nonatomic, strong) NSArray<NewsClassM *> *dataAry;
@property (nonatomic, copy) void (^closeBlock)(void);
@property (nonatomic, copy) void (^confirmBlock)(void);
@property (nonatomic, assign) NewsClassType type;

- (void)showView;

@end

NS_ASSUME_NONNULL_END
