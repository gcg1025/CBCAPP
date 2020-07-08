//
//  ShareV.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/2.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShareType) {
    ShareTypeWX,
    ShareTypeLine
};

NS_ASSUME_NONNULL_BEGIN

@interface ShareV : UIView

@property (copy, nonatomic) void (^shareBlock)(ShareType type);

- (void)showView;

@end

NS_ASSUME_NONNULL_END
