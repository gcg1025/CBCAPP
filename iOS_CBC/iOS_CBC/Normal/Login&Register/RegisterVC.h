#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisterVC : BaseVC

@property (strong, nonatomic) NSString *unionid;

@property (copy, nonatomic) void(^registerSuccessBlock)(void);

@end

NS_ASSUME_NONNULL_END
