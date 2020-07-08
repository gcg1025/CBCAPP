//
//  StoPriceTitleTableCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/19.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "StoPriceTitleTableCell.h"

@interface StoPriceTitleTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *detailsImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *subClassImgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imaVLeaCon;

@end

@implementation StoPriceTitleTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(PriceContentClassM *)model {
    _model = model;
    self.nameLab.text = [[Tool htmlTranslat:model.name font:[UIFont systemFontOfSize:15]].string stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
    self.subClassImgV.alpha = model.ID < 0 ? 1 : 0;
    self.detailsImgV.animationDuration = 0.1;
    self.detailsImgV.animationRepeatCount = 1;
    self.detailsImgV.image = kImage(model.rootID == 0 ? (model.isDetails ? @"price_title_single_details_10" : @"price_title_single_details_00") : (model.isDetails ? @"price_title_double_details_10" : @"price_title_double_details_00"));
    self.imaVLeaCon.constant = model.rootID == 0 ? 10 : 20;
    [self layoutIfNeeded];
}

- (IBAction)selectAct:(id)sender {
    if (self.selectBlock) {
        self.model.isDetails = !self.model.isDetails;
        self.detailsImgV.animationImages = [Tool imagesIsSingle:self.model.rootID == 0 isDetails:self.model.isDetails];
        [self.detailsImgV startAnimating];
        kWeakSelf
        [UIView animateWithDuration:0.1 animations:^{
            weakSelf.detailsImgV.image = kImage(self.model.rootID == 0 ? (self.model.isDetails ? @"price_title_single_details_10" : @"price_title_single_details_00") : (self.model.isDetails ? @"price_title_double_details_10" : @"price_title_double_details_00"));
        }];
        self.selectBlock(self.model);
    }
}


@end
