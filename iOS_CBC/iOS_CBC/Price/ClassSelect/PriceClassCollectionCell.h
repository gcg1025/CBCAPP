//
//  PriceClassCollectionCell.h
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/25.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PriceClassCollectionCell : UICollectionViewCell

@property (nonatomic, strong) PriceClassM *model;
@property (nonatomic, assign) BOOL isTitle;

@end

NS_ASSUME_NONNULL_END
