//
//  NewsCell.m
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/23.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import "NewsCell.h"

@interface NewsCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *sourceLab;

@end

@implementation NewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    CGRect rect = CGRectMake(0, 0, self.mj_w, self.mj_h);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //高亮颜色值
//    UIColor *selectedColor = kHexColor(kTintColorHex, 0.5);
//    CGContextSetFillColorWithColor(context, [selectedColor CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:image];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setModel:(NewsM *)model {
    _model = model;
    self.titleLab.text = model.title;
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDateFormatter *dayFormatterL = [[NSDateFormatter alloc] init];
    [dayFormatterL setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:ss"];
    NSArray *dateAry = [model.adate componentsSeparatedByString:@" "];
    if (dateAry.count == 2) {
        self.timeLab.text = [[dayFormatter stringFromDate:[dayFormatter dateFromString:dateAry[0]]] isEqualToString:[dayFormatter stringFromDate:[NSDate date]]] ? [timeFormatter stringFromDate:[timeFormatter dateFromString:dateAry[1]]] : [dayFormatterL stringFromDate:[dayFormatter dateFromString:dateAry[0]]];
        self.timeLab.textColor = kHexColor([[dayFormatter stringFromDate:[dayFormatter dateFromString:dateAry[0]]] isEqualToString:[dayFormatter stringFromDate:[NSDate date]]] ? @"EE273C" : @"9A9A9A", 1);
    }
    self.sourceLab.text = model.source;
}

@end
