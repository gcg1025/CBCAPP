//
//  NewsTypeCollectionCell.h
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/30.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsTypeCollectionCell : UICollectionViewCell

@property (nonatomic, strong) PageTitleM *model;
@property (nonatomic, assign) BOOL isCurrentType;

@end

NS_ASSUME_NONNULL_END
