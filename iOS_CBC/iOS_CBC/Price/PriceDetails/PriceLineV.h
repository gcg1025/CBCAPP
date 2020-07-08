//
//  PriceLineV.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/6/21.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PriceLineVType) {
    PriceLineVTypeRequest,
    PriceLineVTypeSuccess,
    PriceLineVTypefail
};

@interface PriceLineV : UIView

@property (nonatomic, assign) PriceLineVType type;
@property (nonatomic, assign) BOOL isFull;
@property (nonatomic, assign) NSInteger currentLineIndex;
@property (nonatomic, strong) PriceDetailsLineM *model;
@property (nonatomic, copy) void (^backBlock)(void);
@property (nonatomic, copy) void (^selectBlock)(NSInteger tag);
@property (nonatomic, copy) void (^reloadBlock)(void);
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *tipTitle;
@property (nonatomic, strong) NSString *tipUnitStr;

@end

NS_ASSUME_NONNULL_END
