
#import "NaviV.h"

@interface NaviV ()

@end

@implementation NaviV

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kHexColor(kNavBackgroundColorHex, 1);
        
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kStatusH, 44, 44)];
        self.backImageView.image = kImage(@"nav_left_back_white");
        self.backImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.backImageView];

        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 100, 20)];
        self.titleLab.textColor = [UIColor whiteColor];
        self.titleLab.font = [UIFont systemFontOfSize:17];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.center = CGPointMake(kScreenW / 2, kStatusH + 22);
        [self addSubview:self.titleLab];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn.frame = CGRectMake(kScreenW - 44, kStatusH, 44, 44);
        self.rightBtn.alpha = 0;
        [self addSubview:self.rightBtn];
        
        self.rightL = [[UILabel alloc] init];
        self.rightL.frame = CGRectMake(kScreenW - 92, kStatusH, 80, 44);
        self.rightL.alpha = 0;
        self.rightL.textAlignment = NSTextAlignmentRight;
        self.rightL.textColor = kHexColor(@"202020", 1);
        self.rightL.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.rightL];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title hasBackBtn:(BOOL)hasOrNot {
    NaviV *navigationView = [[NaviV alloc] initWithFrame:frame];
    navigationView.titleLab.text = title;
    [navigationView.rightBtn addTarget:self action:@selector(rightAct:) forControlEvents:UIControlEventTouchUpInside];
    if (!hasOrNot) {
        [navigationView.backImageView removeFromSuperview];
    }
    return navigationView;
}

+ (instancetype)navigationViewWithFrame:(CGRect)frame title:(NSString *)title hasBackBtn:(BOOL)hasOrNot {
    return [[NaviV alloc] initWithFrame:frame title:title hasBackBtn:hasOrNot];
}

// 返回方法
- (void)backToSuperView:(UIButton *)btn {
    UIResponder *responder = btn;
    do {
        responder = responder.nextResponder;
    } while (![responder isKindOfClass:[UIViewController class]]);
    
    UIViewController *currentController = (UIViewController *)responder;
    if ([currentController isKindOfClass:[BaseVC class]]) {
        [((BaseVC *)currentController) resignAct];
    }
    [currentController.navigationController popViewControllerAnimated:true];
}

// 返回方法
- (void)rightAct:(UIButton *)btn {
    UIResponder *responder = btn;
    do {
        responder = responder.nextResponder;
    } while (![responder isKindOfClass:[UIViewController class]]);
    
    UIViewController *currentController = (UIViewController *)responder;
    if ([currentController isKindOfClass:[BaseVC class]]) {
        [((BaseVC *)currentController) resignAct];
//        [((BaseVC *)currentController) shareAct];
        [((BaseVC *)currentController) rightAct];
    }
}

@end
