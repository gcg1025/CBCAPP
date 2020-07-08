//
//  NewsClassContentV.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/29.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsClassContentV : UIView

@property (nonatomic, strong) NewsClassM *model;
@property (nonatomic, strong) NewsClassM *selectModel;
@property (nonatomic, copy) void (^selectBlock)(NewsClassM *model);
@property (nonatomic, copy) void (^allBlock)(NewsClassM *model, BOOL isSelect);

- (void)reloadItemsAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
