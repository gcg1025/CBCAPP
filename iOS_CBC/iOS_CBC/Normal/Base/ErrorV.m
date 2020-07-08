#import "ErrorV.h"

@interface ErrorV ()

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *buttonL;

@end

@implementation ErrorV

- (void)setViewType:(ErrorViewType)viewType {
    switch (viewType) {
        case ErrorViewTypeReload:
            self.img.image = kImage(@"default_neterror");
            self.titleL.text = @"获取数据失败";
            self.buttonL.text = @"点击获取";
            break;
        case ErrorViewTypeLogin:
            self.img.image = kImage(@"default_neterror");
            self.titleL.text = @"登录后可以查看数据";
            self.buttonL.text = @"点击登录";
            break;
        default:
            break;
    }
}


- (IBAction)buttonAct:(UIButton *)sender {
    if (self.buttonClick) {
        self.buttonClick();
    }
}


@end
