#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ErrorViewType) {
    ErrorViewTypeReload,
    ErrorViewTypeLogin
};


NS_ASSUME_NONNULL_BEGIN

@interface ErrorV: UIView

@property (assign, nonatomic) ErrorViewType viewType;
@property (copy, nonatomic) void(^buttonClick)(void);

@end

NS_ASSUME_NONNULL_END
