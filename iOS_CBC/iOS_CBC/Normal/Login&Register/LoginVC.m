#import "LoginVC.h"
#import "RegisterVC.h"

@interface LoginVC () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneT;
@property (weak, nonatomic) IBOutlet UITextField *passwordT;
@property (weak, nonatomic) IBOutlet UIImageView *passwordSecretImg;

@property (weak, nonatomic) IBOutlet UIButton *loginB;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViews];
}

- (void)backAct {
    [Tool dismiss];
    [self.navigationController popViewControllerAnimated:true];
}

- (void)setViews {
    [self setNavigationBarWithTitle:@"登录" hasBackBtn:true];
    [self setTextFields];
}

- (void)setTextFields {
    self.phoneT.text = [[Tool userPhone] isEqualToString:kPhone] ? @"" : [Tool userPhone];
    self.passwordT.text = [[Tool userPassword] isEqualToString:kPassword] ? @"" : [Tool userPassword];
}

- (IBAction)passwordSecretAct:(id)sender {
    self.passwordT.secureTextEntry = !self.passwordT.secureTextEntry;
    self.passwordSecretImg.image = kImage(self.passwordT.secureTextEntry ? @"login_pwd_secret" : @"login_pwd_unsecret");
}


- (IBAction)registerAct:(UIButton *)sender {
    RegisterVC *vc = [[RegisterVC alloc] initWithNibName:@"RegisterVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)loginAct:(UIButton *)sender {
    [self resignAct];
    if (self.isRequest) {
        return;
    }
    if (![Tool isPhoneNumber:self.phoneT.text]) {
        [Tool showStatusDark:@"请填写正确的手机号"];
        return;
    }
    if (self.passwordT.text.length < 1) {
        [Tool showStatusDark:@"请填写密码"];
        return;
    }
    [Tool showProgressDark];
    self.isRequest = true;
    kWeakSelf
    [Tool POST:LOGIN params:@[@{@"loginname":self.phoneT.text}, @{@"loginpass":self.passwordT.text}, @{@"pass":PASS}] progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSDictionary * _Nonnull result) {
        weakSelf.isRequest = false;
        UserM *model = [UserM mj_objectArrayWithKeyValuesArray:result[@"logininfo"]].firstObject;
        if (model.ID) {
//            [Tool shareInstance].shouldLogin = false;
            [Tool saveUserPhone:weakSelf.phoneT.text];
            [Tool saveUserPassword:weakSelf.passwordT.text];
            [Tool saveUserInfo:model];
            if (weakSelf.loginSuccessBlock) {
                weakSelf.loginSuccessBlock();
            }
            [weakSelf performSelector:@selector(backAct) withObject:nil afterDelay:1];
        } else {
            [Tool showStatusDark:@"用户名密码登录失败"];
        }
    } failure:^(NSString * _Nonnull error) {
        weakSelf.isRequest = false;
        [Tool showStatusDark:@"请求错误"];
    }];
}

- (IBAction)resignTap:(UITapGestureRecognizer *)sender {
    [self resignAct];
}

- (void)resignAct {
    [self.phoneT resignFirstResponder];
    [self.passwordT resignFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

