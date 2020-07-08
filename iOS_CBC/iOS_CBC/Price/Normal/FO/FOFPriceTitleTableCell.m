//
//  FOFPriceTitleTableCell.m
//  iOS_CBC
//
//  Created by 张贺 on 2020/2/21.
//  Copyright © 2020 zhiliao. All rights reserved.
//

#import "FOFPriceTitleTableCell.h"

@interface FOFPriceTitleTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *detailsImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *unitLab;

@end


@implementation FOFPriceTitleTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(PriceFOClassM *)model {
    _model = model;
    self.nameLab.text = model.name;
    self.detailsImgV.animationDuration = 0.1;
    self.detailsImgV.animationRepeatCount = 1;
    self.detailsImgV.image = kImage(model.isDetails ? @"price_title_single_details_10" : @"price_title_single_details_00");
    self.unitLab.text = model.typeName;
}

- (IBAction)selectAct:(id)sender {
    if (self.selectBlock) {
        self.model.isDetails = !self.model.isDetails;
        self.detailsImgV.animationImages = [Tool imagesIsSingle:true isDetails:self.model.isDetails];
        [self.detailsImgV startAnimating];
        kWeakSelf
        [UIView animateWithDuration:0.1 animations:^{
            weakSelf.detailsImgV.image = kImage(self.model.isDetails ? @"price_title_single_details_10" : @"price_title_single_details_00");
        }];
        self.selectBlock(self.model);
    }
}

@end
