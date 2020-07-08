#import <UIKit/UIKit.h>
#import "NaviV.h"
#import "ErrorV.h"
#import "RequestV.h"
#import "BaseTV.h"
#import "BaseCV.h"
#import "BasePageV.h"
#import "LoginV.h"
#import "NoDataV.h"
#import "AlertV.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseVC : UIViewController

@property (assign, nonatomic) BOOL isRequest;
@property (strong, nonatomic) NaviV *navigationView;
@property (strong, nonatomic) ErrorV *errorV;
@property (strong, nonatomic) RequestV *requestV;
@property (strong, nonatomic) BasePageV *basePageV;
@property (strong, nonatomic) BaseTV *baseTV;
@property (strong, nonatomic) BaseCV *baseCV;
@property (nonatomic, strong) AlertV *alertV;
@property (nonatomic, assign) BOOL shouleRefresh;
@property (nonatomic, assign) CGFloat kScale;

- (void)setNavigationBarWithTitle:(NSString *)title hasBackBtn:(BOOL)hasOrNot;
- (void)setViews;
- (void)setText;
- (void)resetViews;
- (void)resignAct;
- (void)backAct;
- (void)rightAct;
- (void)shareAct;
- (void)reloadData;
- (void)requestData;
- (void)requestError;
- (void)updateData;
- (void)loginAct;
- (void)toOrderAct;
- (ErrorV *)createErrorV;
- (RequestV *)createRequestV;
- (void)loginVCLoginSuccess:(void(^)(void))loginSuccess;
- (void)alertTitle:(NSString *)title message:(NSString *)message sureActionTitle:(NSString *)sureTitle sureAction:(void (^ __nullable)(UIAlertAction *action))sureAction cacelActionTitle:(NSString *)cancelTitle cancelAction:(void (^ __nullable)(UIAlertAction *action))cancelAction;
- (void)alertTitle:(NSString *)title message:(NSString *)message destructiveActionTitle:(NSString *)destructiveTitle destructiveAction:(void (^ __nullable)(UIAlertAction *action))destructiveAction cacelActionTitle:(NSString *)cancelTitle cancelAction:(void (^ __nullable)(UIAlertAction *action))cancelAction;

@end

NS_ASSUME_NONNULL_END
