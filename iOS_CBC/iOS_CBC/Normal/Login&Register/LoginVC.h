#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginVC : BaseVC

@property (copy, nonatomic) void(^loginSuccessBlock)(void);

@end

NS_ASSUME_NONNULL_END
