//
//  OrderPayTimeTableCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/3/23.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "OrderPayTimeTableCell.h"

@interface OrderPayTimeTableCell ()

@property (weak, nonatomic) IBOutlet UIView *timeV1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeNewPriceLabTopCon1;
@property (weak, nonatomic) IBOutlet UILabel *timeNewPriceLab1;
@property (weak, nonatomic) IBOutlet UILabel *timeOldPriceLab1;

@property (weak, nonatomic) IBOutlet UIView *timeV2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeNewPriceLabTopCon2;
@property (weak, nonatomic) IBOutlet UILabel *timeNewPriceLab2;
@property (weak, nonatomic) IBOutlet UILabel *timeOldPriceLab2;

@property (weak, nonatomic) IBOutlet UIView *timeV3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeNewPriceLabTopCon3;
@property (weak, nonatomic) IBOutlet UILabel *timeNewPriceLab3;
@property (weak, nonatomic) IBOutlet UILabel *timeOldPriceLab3;

@end

@implementation OrderPayTimeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.index = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(OrderInfoM *)model {
    _model = model;
    self.timeV1.layer.borderWidth = 0.5;
    self.timeV2.layer.borderWidth = 0.5;
    self.timeV3.layer.borderWidth = 0.5;
    self.timeV1.layer.borderColor = kHexColor(@"245286", 1).CGColor;
    self.timeV2.layer.borderColor = kHexColor(@"245286", 1).CGColor;
    self.timeV3.layer.borderColor = kHexColor(@"245286", 1).CGColor;
    [self setViews];
}

- (void)setViews {
    NSString *str1 = [NSString stringWithFormat:@"%@年", self.model.year1];
    NSString *str2 = [NSString stringWithFormat:@"¥%@", self.model.price1_new];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", str1, str2]];
    [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:kHexColor(self.index == 0 ? @"ffffff" : @"245286", 1)} range:NSMakeRange(0, str.length)];
    if (self.index != 0) {
        [str addAttributes:@{NSForegroundColorAttributeName:kHexColor(@"C80000", 1)} range:[str.string rangeOfString:str2]];
    }
    self.timeNewPriceLab1.attributedText = str;
    if (self.model.price1_new.floatValue == self.model.price1_old.floatValue) {
        self.timeOldPriceLab1.text = @"";
        self.timeNewPriceLabTopCon1.constant = 20;
    } else {
        str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价：¥%@", self.model.price1_old]];
        [str addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid), NSStrikethroughColorAttributeName:self.index == 0 ? [UIColor whiteColor] : [UIColor darkGrayColor], NSForegroundColorAttributeName:self.index == 0 ? [UIColor whiteColor] : [UIColor darkGrayColor]} range:NSMakeRange(0, str.string.length)];
        self.timeOldPriceLab1.attributedText = str;
        self.timeNewPriceLabTopCon1.constant = 11;
    }
    
    str1 = [NSString stringWithFormat:@"%@年", self.model.year2];
    str2 = [NSString stringWithFormat:@"¥%@", self.model.price2_new];
    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", str1, str2]];
    [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:kHexColor(self.index == 1 ? @"ffffff" : @"245286", 1)} range:NSMakeRange(0, str.length)];
    if (self.index != 1) {
        [str addAttributes:@{NSForegroundColorAttributeName:kHexColor(@"C80000", 1)} range:[str.string rangeOfString:str2]];
    }
    self.timeNewPriceLab2.attributedText = str;
    if (self.model.price2_new.floatValue == self.model.price2_old.floatValue) {
        self.timeOldPriceLab2.text = @"";
        self.timeNewPriceLabTopCon2.constant = 20;
    } else {
        str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价：¥%@", self.model.price2_old]];
        [str addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid), NSStrikethroughColorAttributeName:self.index == 1 ? [UIColor whiteColor] : [UIColor darkGrayColor], NSForegroundColorAttributeName:self.index == 1 ? [UIColor whiteColor] : [UIColor darkGrayColor]} range:NSMakeRange(0, str.string.length)];
        self.timeOldPriceLab2.attributedText = str;
        self.timeNewPriceLabTopCon2.constant = 11;
    }
    
    str1 = [NSString stringWithFormat:@"%@年", self.model.year3];
    str2 = [NSString stringWithFormat:@"¥%@", self.model.price3_new];
    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", str1, str2]];
    [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:kHexColor(self.index == 2 ? @"ffffff" : @"245286", 1)} range:NSMakeRange(0, str.length)];
    if (self.index != 2) {
        [str addAttributes:@{NSForegroundColorAttributeName:kHexColor(@"C80000", 1)} range:[str.string rangeOfString:str2]];
    }
    self.timeNewPriceLab3.attributedText = str;
    if (self.model.price3_new.floatValue == self.model.price3_old.floatValue) {
        self.timeOldPriceLab3.text = @"";
        self.timeNewPriceLabTopCon3.constant = 20;
    } else {
        str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价：¥%@", self.model.price3_old]];
        [str addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid), NSStrikethroughColorAttributeName:self.index == 2 ? [UIColor whiteColor] : [UIColor darkGrayColor], NSForegroundColorAttributeName:self.index == 2 ? [UIColor whiteColor] : [UIColor darkGrayColor]} range:NSMakeRange(0, str.string.length)];
        self.timeOldPriceLab3.attributedText = str;
        self.timeNewPriceLabTopCon3.constant = 11;
    }
    
    self.timeV1.backgroundColor = kHexColor(self.index == 0 ? @"245286" : @"ffffff", 1);
    self.timeV2.backgroundColor = kHexColor(self.index == 1 ? @"245286" : @"ffffff", 1);
    self.timeV3.backgroundColor = kHexColor(self.index == 2 ? @"245286" : @"ffffff", 1);
}

- (IBAction)selectAct:(UIButton *)sender {
    if (self.index != sender.tag - 30000) {
        self.index = sender.tag - 30000;
        self.selectBlock(self.index, ((NSArray<NSString *> *)@[self.model.price1_new, self.model.price2_new, self.model.price3_new])[self.index]);
        [self setViews];
    }
}

@end
