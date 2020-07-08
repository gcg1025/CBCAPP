#import <Foundation/Foundation.h>
#import "BaseM.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tool : NSObject

@property (strong, nonatomic) UserM * __nullable user;
@property (strong, nonatomic) BaseVC * __nullable currentViewController;
@property (nonatomic, assign) BOOL shouldUpdate;
@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, assign) BOOL shouldLogin;
@property (nonatomic, assign) BOOL shouldRequestOrder;

+ (instancetype)shareInstance;

+ (BOOL)isRightVersion;

+ (NSArray *)metalAry;
+ (NSString *)metalNameWithID:(NSInteger)ID;
+ (NSArray *)distributionAry;
+ (NSArray *)supplyPurchaseAry;
+ (NSArray *)futureAry;
+ (NSArray *)orgnizationAry;
+ (NSArray *)bidAry;

+ (void)saveUserPhone:(NSString *)phone;
+ (NSString *)userPhone;
+ (void)saveUserPassword:(NSString *)password;
+ (NSString *)userPassword;
+ (void)saveUserInfo:(UserM *)user;
+ (void)logOut;

+ (NSArray *)priceClassIDAry;
+ (void)setPriceClassIDAry:(NSArray<PriceClassM *> *)ary;

+ (NSString *)bjjgNameStringWithID:(NSInteger)ID isFutures:(BOOL)isFutures;
+ (NSString *)bjjgIdStringWithID:(NSInteger)ID isFutures:(BOOL)isFutures;
+ (NSString *)updateMarkTypeStringWithID:(NSInteger)ID isFutures:(BOOL)isFutures;

+ (NSArray *)newsClassIDAry;
+ (void)setNewsClassIDAry:(NSArray<NSString *> *)ary;
+ (NSArray *)newsClassAnalyseIDAry;
+ (void)setNewsClassAnalyseIDAry:(NSArray<NSString *> *)ary;
+ (NSArray *)newsClassSortAry;
+ (void)setNewsClassSortAry:(NSArray<NSString *> *)ary;

+ (UIColor *)hexColor:(NSString *)hexColor alpha:(CGFloat)alpha;

+ (void)POST:(NSString *)api params:(NSArray *)params progress:(void (^)(NSProgress *progress))uploadProgress success:(void (^)(NSDictionary *result))success
     failure:(void (^)(NSString *error))failure;

+ (BOOL)isPhoneNumber:(NSString *)patternStr;
+ (BOOL)detectionIsEmailQualified:(NSString *)patternStr;
+ (BOOL)detectionIsPasswordQualified:(NSString *)patternStr;
+ (BOOL)detectionIsIdCardNumberQualified:(NSString *)patternStr;
+ (BOOL)detectionIsIPAddress:(NSString *)patternStr;
+ (BOOL)detectionIsAllNumber:(NSString *)patternStr;
+ (BOOL)detectionIsEnglishAlphabet:(NSString *)patternStr;
+ (BOOL)detectionIsUrl:(NSString *)patternStr;
+ (BOOL)detectionIsChinese:(NSString *)patternStr;
+ (BOOL)detectionNormalText:(NSString *)normalStr WithHighLightText:(NSString *)HighLightStr;

// 白色提示
+ (void)showStatusLight:(NSString *)status;
+ (void)showLongStatusLight:(NSString *)status;

// 黑色提示
+ (void)showStatusDark:(NSString *)status;
+ (void)showLongStatusDark:(NSString *)status;
+ (void)showLongLongStatusDark:(NSString *)status;
+ (void)showProgressDark;
+ (void)showProgressStatusDark:(NSString *)status;
+ (void)showSuccessStatusDark:(NSString *)status;
+ (void)showProgress:(CGFloat)progress status:(NSString *)status;

+ (void)dismiss;

+ (NSString *)updateTimeForRow:(double)time;
+ (NSString *)time:(double)time withFormatter:(NSString *)formatter;
+ (NSString *)countDownTime:(double)time ;

+ (CGFloat)heightForString:(NSString *)string font:(UIFont *)font;
+ (CGFloat)heightForString:(NSString *)string width:(CGFloat)width font:(UIFont *)font;
+ (CGFloat)widthForString:(NSString *)string font:(UIFont *)font;
+ (CGFloat)widthForString:(NSString *)string height:(CGFloat)height font:(UIFont *)font;

+ (NSString *)numberTranslat:(NSInteger)number;
+ (NSAttributedString *)htmlTranslat:(NSString *)htmlString font:(UIFont *)font;

+ (NSArray<UIImage *> *)imagesIsSingle:(BOOL)isSingle isDetails:(BOOL)isDetails;

+ (NSString *)transPrice:(NSString *)price;
+ (NSString *)decryptString:(NSString *)str;

+ (NSString *)transYear:(NSString *)year;

+ (void)getAdImg;

+ (NSString *)transFloat:(NSString *)string digits:(NSInteger)digits  usesGroupingSeparator:(BOOL)usesGroupingSeparator;

@end

NS_ASSUME_NONNULL_END
