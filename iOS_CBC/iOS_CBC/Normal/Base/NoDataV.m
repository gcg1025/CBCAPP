#import "NoDataV.h"

@interface NoDataV ()

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end

@implementation NoDataV

- (void)setViewType:(NoDataViewType)viewType {
    switch (viewType) {
        case NoDataViewTypePrice:
            self.img.image = kImage(@"default_price");
            self.lab.text = @"暂无价格信息";
            break;
        case NoDataViewTypeNews:
            self.img.image = kImage(@"default_news");
            self.lab.text = @"暂无资讯信息";
            break;
        case NoDataViewTypeDistribution:
            self.img.image = kImage(@"default_distribution");
            self.lab.text = @"暂无发布信息";
            break;
        case NoDataViewTypeSupply:
            self.img.image = kImage(@"default_distribution");
            self.lab.text = @"暂无供应信息";
            break;
        case NoDataViewTypePurchase:
            self.img.image = kImage(@"default_distribution");
            self.lab.text = @"暂无求购信息";
            break;
        case NoDataViewTypeOrder:
            self.img.image = kImage(@"default_price");
            self.lab.text = @"暂无订单信息";
            break;
        case NoDataViewTypeCustomize:
            self.img.image = kImage(@"default_price");
            self.lab.text = @"您还没有定制地区价格信息";
            break;
        case NoDataViewTypeFutures:
            self.img.image = kImage(@"default_price");
            self.lab.text = @"暂无期货价格信息";
            break;
            case NoDataViewTypeOrgnization:
            self.img.image = kImage(@"default_price");
            self.lab.text = @"暂无机构价格信息";
            break;
        default:
            break;
    }
    [self layoutIfNeeded];
}

@end
