//
//  TableTitleV.h
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/21.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TableTitleType) {
    TableTitleTypeSto = 0,
    TableTitleTypeEnt = 1,
    TableTitleTypeBid = 2,
    TableTitleTypeFOF = 3,
    TableTitleTypeFOO = 4,
    TableTitleTypeFOFLME = 5,
    TableTitleTypeFOFALL = 6,
    TableTitleTypeFOFALLLEMNormal = 7,
    TableTitleTypeFOFALLLEM = 8,
    TableTitleTypeFOFALLTOCOM = 9,
    TableTitleTypeFOOALLNormal = 10,
    TableTitleTypeFOOALLSHJJS = 11,
    TableTitleTypeFOOALLNFXG = 12,
    TableTitleTypeFOOALLLDGJS = 13
};

NS_ASSUME_NONNULL_BEGIN

@interface TableTitleV : UIView

@property (nonatomic, assign) TableTitleType type;
@property (nonatomic, copy) void (^selectBlock)(void);
@property (nonatomic, strong) NSString *dateStr;

@end

NS_ASSUME_NONNULL_END
