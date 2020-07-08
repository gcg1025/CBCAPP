//
//  PriceDetailsTitleV.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/8.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PriceDetailsTitleType) {
    PriceDetailsTitleType0,
    PriceDetailsTitleType1,
    PriceDetailsTitleType2,
    PriceDetailsTitleType3,
    PriceDetailsTitleType4,
    PriceDetailsTitleType5,
    PriceDetailsTitleType6,
    PriceDetailsTitleType7,
    PriceDetailsTitleType8,
    PriceDetailsTitleType9
};

NS_ASSUME_NONNULL_BEGIN

@interface PriceDetailsTitleV : UIView

@property (nonatomic, assign) PriceDetailsTitleType type;

@end

NS_ASSUME_NONNULL_END
