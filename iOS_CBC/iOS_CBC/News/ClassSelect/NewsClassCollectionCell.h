//
//  NewsClassCollectionCell.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/29.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsClassCollectionCell : UICollectionViewCell

@property (nonatomic, strong) NewsClassM *model;
@property (nonatomic, assign) BOOL isTitle;

@end

NS_ASSUME_NONNULL_END
