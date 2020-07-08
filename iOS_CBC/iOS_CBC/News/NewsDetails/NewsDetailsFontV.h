//
//  NewsDetailsFontV.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/25.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsDetailsFontV : UIView

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void (^selectBlock)(NSInteger index);

- (void)showView;
- (void)hideView;

@end

NS_ASSUME_NONNULL_END
