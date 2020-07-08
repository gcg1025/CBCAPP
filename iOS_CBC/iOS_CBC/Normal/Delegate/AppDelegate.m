//
//  AppDelegate.m
//  iOS_CBC
//
//  Created by SDB_Mac on 2019/12/20.
//  Copyright © 2019 zhiliao. All rights reserved.
//

#import "AppDelegate.h"
#import <MOBFoundation/MobSDK+Privacy.h>
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    IQKeyboardManager.sharedManager.enable = true;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = true;
    
    [WXApi registerApp:@"wxe5e2088316110187" universalLink:@"https://vlsit.share2dlink.com/"];
    
    [MobSDK uploadPrivacyPermissionStatus:YES onResult:^(BOOL success) {
    }];
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        [platformsRegister setupWeChatWithAppId:@"wxe5e2088316110187" appSecret:@"3150cbd9c836b573166bee0236149327" universalLink:@"https://vlsit.share2dlink.com/"];
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    kSetValueForKey(@([NSDate date].timeIntervalSince1970).stringValue, kTime);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([Tool shareInstance].shouldRequestOrder && [Tool shareInstance].currentViewController) {
        if ([[Tool shareInstance].currentViewController isKindOfClass:[OrderPayVC class]]) {
            [Tool shareInstance].shouldRequestOrder = false;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeOrderRefresh object:nil];
        }
    }
    
    NSString *time = kValueForKey(kTime);
    if (time) {
        if ([NSDate date].timeIntervalSince1970 - time.doubleValue > 30 * 60) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeUserUpdate object:nil];
        }
        if ([NSDate date].timeIntervalSince1970 - time.doubleValue > 6 * 60 * 60) {
            if ([Tool shareInstance].user && [Tool shareInstance].isLoaded) {
                [Tool showStatusDark:@"登录失效，请重新登录"];
                [Tool logOut];
                [Tool shareInstance].shouldLogin = true;
                [self toHome];
            }
        } else {
            if ([Tool shareInstance].user && [Tool shareInstance].isLoaded && [Tool shareInstance].user.token) {
                kWeakSelf
                [Tool POST:TOKEN params:@[@{@"pass":PASS}, @{@"vipid":[Tool shareInstance].user.ID}, @{@"token":[Tool shareInstance].user.token}] progress:^(NSProgress * _Nonnull progress) {
                    
                } success:^(NSDictionary * _Nonnull result) {
                    if (result) {
                        if ([result.allKeys containsObject:@"CheckState"]) {
                            if ([result[@"CheckState"] integerValue] != 1) {
                                [Tool showStatusDark:@"登录失效，请重新登录"];
                                [Tool logOut];
                                [Tool shareInstance].shouldLogin = true;
                                [weakSelf toHome];
                            }
                        }
                    }
                } failure:^(NSString * _Nonnull error) {
                    
                }];
            }
        }
    }
    if ([Tool shareInstance].isLoaded) {
        if (![Tool isRightVersion]) {
            [Tool shareInstance].shouldUpdate = true;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeAppUpdate object:nil];
        }
    } else {
        [Tool POST:VERSION params:@[@{@"pass":PASS}] progress:^(NSProgress * _Nonnull progress) {

        } success:^(NSDictionary * _Nonnull result) {
            if (result[@"iosedition"]) {
                kSetValueForKey(result[@"iosedition"], kVersionStoreKey);
            }
            if (result[@"iosupdatememo"]) {
                kSetValueForKey(result[@"iosupdatememo"], kVersionContentKey);
            }
            if (![Tool isRightVersion]) {
                [Tool shareInstance].shouldUpdate = true;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeAppUpdate object:nil];
            }
        } failure:^(NSString * _Nonnull error) {

        }];
    }
    
}

- (void)toHome {
    self.window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
}

@end
