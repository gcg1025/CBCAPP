//
//  AlertUpdateV.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/21.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertUpdateV : UIView

@property (nonatomic, copy) void (^updateBlock)(void);

- (void)showView;

@end

NS_ASSUME_NONNULL_END
