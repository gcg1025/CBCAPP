//
//  NewsClassTableCell.h
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/30.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsClassTableCell : UITableViewCell

@property (nonatomic, strong) NewsClassM *model;
@property (weak, nonatomic) IBOutlet UIView *dragV;

@end

NS_ASSUME_NONNULL_END
