//
//  MineTableCell.m
//  iOS_CBC
//
//  Created by SDB_Mac on 2020/1/3.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "MineTableCell.h"

@interface MineTableCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation MineTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGRect rect = CGRectMake(0, 0, self.mj_w, self.mj_h);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //高亮颜色值
    UIColor *selectedColor = kHexColor(kTintColorHex, 0.5);
    CGContextSetFillColorWithColor(context, [selectedColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:image];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLab.text = name;
}

@end
