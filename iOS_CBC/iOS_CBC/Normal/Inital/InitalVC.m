//
//  InitalVC.m
//  Axym-customer
//
//  Created by Mac book on 2019/8/6.
//  Copyright © 2019 Mac book. All rights reserved.
//

#import "InitalVC.h"
#import "ADVC.h"

@interface InitalVC ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityV;
@property (assign, nonatomic) BOOL isGoing;
@property (weak, nonatomic) IBOutlet UIImageView *launchImgV;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *skipLab;
@property (weak, nonatomic) IBOutlet UIView *countDownV;

@end

@implementation InitalVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.activityV startAnimating];
    [Tool getAdImg];
    [self autoLogin];
}

- (void)autoLogin {
    if ([Tool shareInstance].user && [Tool shareInstance].user.token) {
        kWeakSelf
        [Tool POST:TOKEN params:@[@{@"pass":PASS}, @{@"vipid":[Tool shareInstance].user.ID}, @{@"token":[Tool shareInstance].user.token}] progress:^(NSProgress * _Nonnull progress) {
            
        } success:^(NSDictionary * _Nonnull result) {
            if ([result[@"CheckState"] integerValue] != 1) {
                [Tool showStatusDark:@"登录失效，请重新登录"];
                [Tool logOut];
                [Tool shareInstance].shouldLogin = true;
            }
            [weakSelf checkAdAct];
        } failure:^(NSString * _Nonnull error) {
            [Tool logOut];
            [weakSelf checkAdAct];
        }];
    } else {
        [self checkAdAct];
    }
}

- (void)checkAdAct {
    BOOL isAd = false;
    if (kValueForKey(kADPicKey)) {
        NSString *url = kValueForKey(kADPicKey);
        if (url.length > 5) {
            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", [kValueForKey(kADPicKey) componentsSeparatedByString:@"/"].lastObject]];
            BOOL isDir = NO;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:path isDirectory:&isDir]) {
                isAd = true;
                self.launchImgV.image = [UIImage imageWithContentsOfFile:path];
            }
        }
    }
    if (isAd) {
        self.countDownV.alpha = 0.7;
        NSString *down = kValueForKey(kADDownKey) ? kValueForKey(kADDownKey) : @"3";
        if (down.integerValue <= 0) {
            down = @"3";
        }
        self.count = down.integerValue;
        self.skipLab.text = [NSString stringWithFormat:@"%ldS 跳过", self.count];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:true];
    } else {
        self.countDownV.alpha = 0;
        [self toHome];
    }
}

- (void)countDown {
    self.count -= 1;
    self.skipLab.text = [NSString stringWithFormat:@"%ldS 跳过", self.count];
    if (self.count == 0) {
        [self.timer invalidate];
        [self toHome];
    }
}

- (IBAction)skipAct:(id)sender {
    [self.timer invalidate];
    [self toHome];
}

- (IBAction)toAdDetailsAct:(id)sender {
    if (self.countDownV.alpha != 0 && kValueForKey(kADLinkKey)) {
        NSString *url = kValueForKey(kADLinkKey);
        if (url.length > 5) {
            [self.timer invalidate];
            ADVC *vc = [[ADVC alloc] init];
            vc.url = url;
            [self.navigationController pushViewController:vc animated:true];
        }
    }
}

- (void)toHome {
    ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
}

@end
