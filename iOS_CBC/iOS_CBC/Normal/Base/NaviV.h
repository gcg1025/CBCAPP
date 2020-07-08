#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NaviV : UIView

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *rightL;

+ (instancetype)navigationViewWithFrame:(CGRect)frame title:(NSString *)title hasBackBtn:(BOOL)hasOrNot;

@end

NS_ASSUME_NONNULL_END
