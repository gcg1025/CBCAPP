//
//  NewsDetailsVC.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/25.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "BaseVC.h"

typedef NS_ENUM(NSInteger, NewsType) {
    NewsTypeNormal,
    NewsTypeAnalyse,
    NewsTypeBid
};

NS_ASSUME_NONNULL_BEGIN

@interface NewsDetailsVC : BaseVC

@property (nonatomic, assign) NewsType type;
@property (nonatomic, strong) NewsM *model;

@end

NS_ASSUME_NONNULL_END
