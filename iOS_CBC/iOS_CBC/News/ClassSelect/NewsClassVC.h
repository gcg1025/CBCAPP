//
//  NewsClassVC.h
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/30.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsClassVC : BaseVC

@property (nonatomic, copy) void (^changeBlock)(void);
@property (nonatomic, strong) NSArray<NewsClassM *> *dataAry;

@end

NS_ASSUME_NONNULL_END
