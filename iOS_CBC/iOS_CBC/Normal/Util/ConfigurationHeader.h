#ifndef ConfigurationHeader_h
#define ConfigurationHeader_h

typedef NS_ENUM(NSInteger, NewsClassType) {
    NewsClassTypeNormal,
    NewsClassTypeAnalyse
};

#define kVersionKey [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kVersionStoreKey @"version"
#define kVersionContentKey @"versionContent"
#define kADPicKey @"adPicKey"
#define kADLinkKey @"adLinkKey"
#define kADDownKey @"adDownKey"

#define kUser @"user"
#define kPhone @"phone"
#define kPassword @"password"
#define kPriceClass @"priceClass"
#define kNewsClass @"newsClass"
#define kNewsClassSort @"newsClassSort"
#define kNewsClassAnalyse @"newsClassAnalyse"
#define kNoticeUserLogOut @"UserLogOut"
#define kNoticeUserLogIn @"UserLogIn"
#define kNoticeUserUpdate @"UserUpdate"
#define kNoticeAppUpdate @"AppUpdate"
#define kNoticeOrderRefresh @"OrderRefresh"

#define kTime @"kTime"

#define kPhoneError @"icon_normal_login_phone_correct"
#define kPhontCorret @"icon_normal_login_phone_error"
#define kUserIcon @"icon_normal_user_icon"
#define kAgreeIcon @"icon_normal_login_agree_protocol"
#define kDisAgreeIcon @"icon_normal_login_agree_protocol_d"
#define kPlaceholdImg kImage(@"icon_normal_placeholder")

#define kWeakSelf __weak typeof(self) weakSelf = self;
#define kImage(img) [UIImage imageNamed:img]
#define kSetValueForKey(value, key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
#define kValueForKey(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define kRemoveValueForKey(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kStatusH (kScreenH > 800.0f ? 44.0f : 20.0f)
#define kNaviH 44.0f
#define kBottomH (kScreenH > 800.0f ? 34.0f : 0.0f)
#define kTabbarH 49.0f
#define kTopVH (kStatusH + kNaviH)
#define kBottomVH (kTabbarH + kBottomH)
#define kHexColor(col, alp) [Tool hexColor:col alpha:alp]
#define RGB(r,g,b)          [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r,g,b,a)       [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:(a)]

#define kNavBackgroundColorHex @"245286"
#define kTintColorHex @"FF9018"

#define CACHE_PATH_LIST  @"CACHE_PATH_LIST"

#endif /* ConfigurationHeader_h */
